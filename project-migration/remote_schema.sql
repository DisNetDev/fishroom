--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 16.14 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: custom_reading; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.custom_reading AS ENUM (
    'full_name',
    'short_name',
    'steps_in',
    'value'
);


--
-- Name: check_username_existence(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_username_existence(p_username text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_exists boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM public.users
        WHERE LOWER(users.username) = LOWER(p_username)
    ) INTO user_exists;

    RETURN user_exists;
END;
$$;


--
-- Name: downvote_post(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.downvote_post(post_id_param uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
    vote_change text;
BEGIN
    -- Check if the user has already voted
    IF EXISTS (
        SELECT 1 
        FROM votes 
        WHERE user_id = auth.uid() AND post_id = post_id_param
    ) THEN
        -- Get the current vote type
        UPDATE votes v
        SET vote_type = 
            CASE 
                WHEN vote_type = 'upvote' THEN 'downvote'
                WHEN vote_type = 'downvote' THEN 'downvote'
            END
        WHERE user_id = auth.uid() AND post_id = post_id_param
        RETURNING (CASE 
            WHEN v.vote_type = 'upvote' THEN 'switched'
            ELSE 'unchanged'
        END) INTO vote_change;

        
    ELSE
        -- Insert a new downvote if no vote exists
        INSERT INTO votes (user_id, post_id, vote_type)
        VALUES (auth.uid(), post_id_param, 'downvote');

      
    END IF;
END;$$;


--
-- Name: get_current_streak(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_current_streak(input_tank_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
    streak integer := 0;
    last_entry_date date;
BEGIN
    SELECT CAST(created_at AS date) INTO last_entry_date
    FROM tank_readings
    WHERE tank_id = input_tank_id
    ORDER BY created_at DESC
    LIMIT 1;

    WHILE last_entry_date IS NOT NULL LOOP
        streak := streak + 1;

        SELECT CAST(created_at AS date) INTO last_entry_date
        FROM tank_readings
        WHERE tank_id = input_tank_id 
          AND CAST(created_at AS date) = last_entry_date - interval '1 day'
        ORDER BY created_at DESC
        LIMIT 1;

        -- Check if the last_entry_date is still valid
        IF last_entry_date IS NULL THEN
            EXIT; -- Exit the loop if no previous entry is found
        END IF;
    END LOOP;

    RETURN streak;
END;$$;


--
-- Name: get_streak(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_streak(input_tank_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    streak INTEGER := 0;
    last_entry_date DATE;
    current_selected_date DATE;
    today DATE := CURRENT_DATE;
BEGIN
    SELECT CAST(created_at AS DATE) INTO last_entry_date
    FROM tank_readings
    WHERE tank_id = input_tank_id
    ORDER BY created_at DESC
    LIMIT 1;

    IF last_entry_date IS NULL THEN
        RETURN 0;
    END IF;

       IF last_entry_date < today - INTERVAL '1 day' THEN
        RETURN 0;
    END IF;

    FOR current_selected_date IN 
        SELECT DISTINCT CAST(created_at AS DATE) 
        FROM tank_readings
        WHERE tank_id = input_tank_id
        ORDER BY created_at DESC
    LOOP
        IF last_entry_date - INTERVAL '1 day' = current_selected_date THEN
            streak := streak + 1;
            last_entry_date := current_selected_date;
 
        ELSIF last_entry_date - INTERVAL '1 day' > current_selected_date THEN
            EXIT;
        END IF;
    END LOOP;

    RETURN streak+1;
END;
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.users_check (id, email)
  values (new.id, new.email);
  return new;
end;
$$;


--
-- Name: handle_new_user2(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user2() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.users (id, email)
  values (new.id, new.email);
  return new;
end;
$$;


--
-- Name: send_welcome_email(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.send_welcome_email() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Logic to send the welcome email goes here
    -- For example, you might call an external email service
    RAISE NOTICE 'Welcome email sent to: %', NEW.email;
    
    RETURN NEW;
END;
$$;


--
-- Name: upsert_fish_from_suggestion(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.upsert_fish_from_suggestion(p_fish_suggestion_id uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_fish_id uuid;
  v_common_name text;
  v_scientific_name text;
  v_image_url text;
begin
  -- Load suggestion details
  select
    fs.fish,
    fs.common_name,
    fs.scientific_name,
    fs.image_url
  into
    v_fish_id,
    v_common_name,
    v_scientific_name,
    v_image_url
  from public.fish_suggestions fs
  where fs.id = p_fish_suggestion_id;

  if v_fish_id is null then
    raise exception 'Fish suggestion % not found or has null fish id', p_fish_suggestion_id;
  end if;

  -- Upsert fish using the fish id stored in the suggestion
  insert into public.fish (
    id,
    common_name,
    scientific_name,
    image_url
  )
  values (
    v_fish_id,
    v_common_name,
    v_scientific_name,
    v_image_url
  )
  on conflict (id) do update
  set
    common_name = excluded.common_name,
    scientific_name = excluded.scientific_name,
    image_url = excluded.image_url;

  return v_fish_id;
end;
$$;


--
-- Name: upvote_post(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.upvote_post(post_id_param uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
    vote_change text;
BEGIN
    -- Check if the user has already voted
    IF EXISTS (
        SELECT 1 
        FROM votes 
        WHERE user_id = auth.uid() AND post_id = post_id_param
    ) THEN
        -- Get the current vote type
        UPDATE votes v
        SET vote_type = 
            CASE 
                WHEN vote_type = 'downvote' THEN 'upvote'
                WHEN vote_type = 'upvote' THEN 'upvote'
            END
        WHERE user_id = auth.uid() AND post_id = post_id_param
        RETURNING (CASE 
            WHEN v.vote_type = 'downvote' THEN 'switched'
            ELSE 'unchanged'
        END) INTO vote_change;

       
    ELSE
        -- Insert a new upvote if no vote exists
        INSERT INTO votes (user_id, post_id, vote_type)
        VALUES (auth.uid(), post_id_param, 'upvote');

       
    END IF;
END;$$;


--
-- Name: verify_user_account(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verify_user_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Set the email_confirmed_at column to the current timestamp
    UPDATE auth.users
    SET email_confirmed_at = NOW()
    WHERE id = NEW.id;

    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text,
    description text,
    "order" smallint
);


--
-- Name: COLUMN achievements."order"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.achievements."order" IS 'the order it should display in';


--
-- Name: app_defaults; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_defaults (
    id bigint NOT NULL,
    name text,
    value json
);


--
-- Name: app_defaults_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.app_defaults ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.app_defaults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bug_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bug_reports (
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    reporter uuid NOT NULL,
    description text,
    app_version text,
    screenshot_url text,
    is_resolved boolean DEFAULT false,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    updated_at timestamp with time zone,
    resolution_notes text
);


--
-- Name: community_tank_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_tank_posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    title text,
    content text,
    author_id uuid,
    author_name text,
    updated_at timestamp with time zone,
    images text[] DEFAULT '{}'::text[]
);


--
-- Name: community_tank_posts_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_tank_posts_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    post_id uuid DEFAULT gen_random_uuid(),
    user_id uuid DEFAULT gen_random_uuid(),
    username text,
    content text
);


--
-- Name: community_tank_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_tank_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    reporter_id uuid DEFAULT gen_random_uuid(),
    post_id uuid,
    reason text,
    comment_id uuid
);


--
-- Name: fish; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fish (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    common_name text,
    scientific_name text,
    size text,
    tank_size text,
    temp_range text,
    ph_range text,
    image_url text
);


--
-- Name: fish_custom; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fish_custom (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    common_name text,
    scientific_name text,
    image_url text
);


--
-- Name: fish_suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fish_suggestions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    common_name text,
    scientific_name text,
    image_url text,
    created_by uuid,
    fish uuid
);


--
-- Name: login_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_events (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid DEFAULT gen_random_uuid()
);


--
-- Name: logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.login_events ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id text NOT NULL,
    title text,
    subtitle text,
    type text DEFAULT 'product'::text NOT NULL
);


--
-- Name: release_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.release_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    version text,
    notes text
);


--
-- Name: tank_readings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tank_readings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at text NOT NULL,
    owner_id uuid NOT NULL,
    tank_id uuid,
    type text,
    note text,
    image_url text,
    data jsonb,
    water_change_percentage smallint,
    dosages jsonb[] DEFAULT '{}'::jsonb[]
);


--
-- Name: tanks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tanks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    tank_size real,
    tank_measurement text,
    image_url text,
    owner_id uuid,
    name text,
    tank_type text,
    image_local_path text,
    inhabitants jsonb[] DEFAULT '{}'::jsonb[] NOT NULL,
    targets jsonb[] DEFAULT '{}'::jsonb[] NOT NULL,
    achievement_ids text[] NOT NULL,
    streak bigint DEFAULT '0'::bigint
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text,
    premium boolean DEFAULT false NOT NULL,
    settings jsonb,
    username text,
    welcome_email_sent boolean DEFAULT false,
    next_pro_check timestamp with time zone,
    active_subscription text
);


--
-- Name: users_check; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_check (
    id uuid NOT NULL,
    email text
);


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid DEFAULT auth.uid(),
    post_id uuid DEFAULT gen_random_uuid(),
    vote_type text
);


--
-- Name: tanks Tanks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tanks
    ADD CONSTRAINT "Tanks_pkey" PRIMARY KEY (id);


--
-- Name: achievements achievements_order_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_order_key UNIQUE ("order");


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: app_defaults app_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_defaults
    ADD CONSTRAINT app_defaults_pkey PRIMARY KEY (id);


--
-- Name: bug_reports bug_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bug_reports
    ADD CONSTRAINT bug_reports_pkey PRIMARY KEY (id);


--
-- Name: community_tank_posts_comments community_tank_posts_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_posts_comments
    ADD CONSTRAINT community_tank_posts_comments_pkey PRIMARY KEY (id);


--
-- Name: community_tank_posts community_tank_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_posts
    ADD CONSTRAINT community_tank_posts_pkey PRIMARY KEY (id);


--
-- Name: community_tank_reports community_tank_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_reports
    ADD CONSTRAINT community_tank_reports_pkey PRIMARY KEY (id);


--
-- Name: fish_custom fish_custom_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish_custom
    ADD CONSTRAINT fish_custom_pkey PRIMARY KEY (id);


--
-- Name: fish fish_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish
    ADD CONSTRAINT fish_pkey PRIMARY KEY (id);


--
-- Name: fish_suggestions fish_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish_suggestions
    ADD CONSTRAINT fish_suggestions_pkey PRIMARY KEY (id);


--
-- Name: login_events logins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_events
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: release_notes release_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.release_notes
    ADD CONSTRAINT release_notes_pkey PRIMARY KEY (id);


--
-- Name: tank_readings tank_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tank_readings
    ADD CONSTRAINT tank_readings_pkey PRIMARY KEY (id);


--
-- Name: users_check users_check_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_check
    ADD CONSTRAINT users_check_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: bug_reports bug_reports_reporter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bug_reports
    ADD CONSTRAINT bug_reports_reporter_fkey FOREIGN KEY (reporter) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: community_tank_posts_comments community_tank_posts_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_posts_comments
    ADD CONSTRAINT community_tank_posts_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.community_tank_posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: community_tank_reports community_tank_reports_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_reports
    ADD CONSTRAINT community_tank_reports_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.community_tank_posts_comments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: community_tank_reports community_tank_reports_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_reports
    ADD CONSTRAINT community_tank_reports_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.community_tank_posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: community_tank_reports community_tank_reports_reporter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_tank_reports
    ADD CONSTRAINT community_tank_reports_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fish_custom fish_custom_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish_custom
    ADD CONSTRAINT fish_custom_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fish_suggestions fish_suggestions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish_suggestions
    ADD CONSTRAINT fish_suggestions_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fish_suggestions fish_suggestions_created_by_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish_suggestions
    ADD CONSTRAINT fish_suggestions_created_by_fkey1 FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fish_suggestions fish_suggestions_fish_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fish_suggestions
    ADD CONSTRAINT fish_suggestions_fish_fkey FOREIGN KEY (fish) REFERENCES public.fish(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: login_events logins_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_events
    ADD CONSTRAINT logins_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_check users_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_check
    ADD CONSTRAINT users_check_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: users users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: votes votes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.community_tank_posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: votes votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tank_readings Enable All for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable All for users based on user_id" ON public.tank_readings TO authenticated USING ((( SELECT auth.uid() AS uid) = owner_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = owner_id));


--
-- Name: tanks Enable all for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable all for users based on user_id" ON public.tanks TO authenticated USING ((( SELECT auth.uid() AS uid) = owner_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = owner_id));


--
-- Name: community_tank_posts Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users based on user_id" ON public.community_tank_posts FOR DELETE TO authenticated USING ((( SELECT auth.uid() AS uid) = author_id));


--
-- Name: community_tank_posts_comments Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users based on user_id" ON public.community_tank_posts_comments FOR DELETE TO authenticated USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: bug_reports Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.bug_reports FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: community_tank_posts Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.community_tank_posts FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: community_tank_posts_comments Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.community_tank_posts_comments FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: community_tank_reports Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.community_tank_reports FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: fish_custom Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.fish_custom FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: fish_suggestions Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.fish_suggestions FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: login_events Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.login_events FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: tank_readings Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.tank_readings FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: tanks Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.tanks FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: users Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.users FOR SELECT TO authenticated USING (true);


--
-- Name: votes Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.votes FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: bug_reports Enable read access for all authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all authenticated" ON public.bug_reports FOR SELECT TO authenticated USING (true);


--
-- Name: app_defaults Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.app_defaults FOR SELECT USING (true);


--
-- Name: community_tank_posts_comments Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.community_tank_posts_comments FOR SELECT TO authenticated USING (true);


--
-- Name: fish Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.fish FOR SELECT TO authenticated USING (true);


--
-- Name: products Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.products FOR SELECT USING (true);


--
-- Name: release_notes Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.release_notes FOR SELECT USING (true);


--
-- Name: users_check Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.users_check FOR SELECT USING (true);


--
-- Name: achievements Enable read access for authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for authenticated" ON public.achievements FOR SELECT TO authenticated USING (true);


--
-- Name: community_tank_posts Enable read access for authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for authenticated" ON public.community_tank_posts FOR SELECT TO authenticated USING (true);


--
-- Name: fish_custom Enable select for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable select for authenticated users only" ON public.fish_custom FOR SELECT TO authenticated USING (true);


--
-- Name: community_tank_posts Enable update for users based on email; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users based on email" ON public.community_tank_posts FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = author_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = author_id));


--
-- Name: users Enable update for users based on email; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users based on email" ON public.users FOR UPDATE USING (((( SELECT auth.jwt() AS jwt) ->> 'email'::text) = email)) WITH CHECK (((( SELECT auth.jwt() AS jwt) ->> 'email'::text) = email));


--
-- Name: community_tank_posts_comments Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users based on user_id" ON public.community_tank_posts_comments FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = user_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: votes Enable users to delete their own data only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable users to delete their own data only" ON public.votes FOR DELETE TO authenticated USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: votes Enable users to update their own data only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable users to update their own data only" ON public.votes FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = user_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: votes Enable users to view their own data only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable users to view their own data only" ON public.votes FOR SELECT TO authenticated USING (true);


--
-- Name: achievements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;

--
-- Name: app_defaults; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_defaults ENABLE ROW LEVEL SECURITY;

--
-- Name: bug_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bug_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: community_tank_posts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.community_tank_posts ENABLE ROW LEVEL SECURITY;

--
-- Name: community_tank_posts_comments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.community_tank_posts_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: community_tank_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.community_tank_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: fish; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fish ENABLE ROW LEVEL SECURITY;

--
-- Name: fish_custom; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fish_custom ENABLE ROW LEVEL SECURITY;

--
-- Name: fish_suggestions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.fish_suggestions ENABLE ROW LEVEL SECURITY;

--
-- Name: login_events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.login_events ENABLE ROW LEVEL SECURITY;

--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: release_notes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.release_notes ENABLE ROW LEVEL SECURITY;

--
-- Name: tank_readings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tank_readings ENABLE ROW LEVEL SECURITY;

--
-- Name: tanks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tanks ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users_check; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.users_check ENABLE ROW LEVEL SECURITY;

--
-- Name: votes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.votes ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--
