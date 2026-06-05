-- Media Crunchy Supabase Schema Migrations
-- Run these SQL commands in your Supabase SQL editor

-- ============================================================================
-- 1. USERS TABLE - User profiles with roles
-- ============================================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  username TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL DEFAULT 'viewer', -- 'viewer', 'creator', 'admin'
  avatar_url TEXT,
  bio TEXT,
  verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_username ON users(username);

-- Enable RLS on users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can read public profiles
CREATE POLICY "Users can read all profiles"
  ON users FOR SELECT
  USING (true);

-- RLS Policy: Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- RLS Policy: Admins can update any profile
CREATE POLICY "Admins can update any profile"
  ON users FOR UPDATE
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin')
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- ============================================================================
-- 2. VIDEOS TABLE - Content metadata with workflow
-- ============================================================================
CREATE TABLE IF NOT EXISTS videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  creator_name TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  thumbnail TEXT,
  video_url TEXT,
  duration INTEGER DEFAULT 0, -- in seconds
  category TEXT NOT NULL,
  rating DECIMAL(2,1) DEFAULT 0.0,
  status TEXT NOT NULL DEFAULT 'Draft', -- 'Draft', 'Submitted', 'Approved', 'Published', 'Rejected'
  views INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  episodes_count INTEGER DEFAULT 0,
  tags TEXT[] DEFAULT ARRAY[]::TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_videos_creator_id ON videos(creator_id);
CREATE INDEX idx_videos_status ON videos(status);
CREATE INDEX idx_videos_category ON videos(category);
CREATE INDEX idx_videos_created_at ON videos(created_at DESC);
CREATE INDEX idx_videos_rating ON videos(rating DESC);

-- Enable RLS on videos table
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Anyone can read published videos
CREATE POLICY "Anyone can read published videos"
  ON videos FOR SELECT
  USING (status = 'Published');

-- RLS Policy: Creators can read their own videos
CREATE POLICY "Creators can read own videos"
  ON videos FOR SELECT
  USING (creator_id = auth.uid());

-- RLS Policy: Admins can read all videos
CREATE POLICY "Admins can read all videos"
  ON videos FOR SELECT
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- RLS Policy: Creators can create videos
CREATE POLICY "Creators can create videos"
  ON videos FOR INSERT
  WITH CHECK (
    creator_id = auth.uid() AND
    (SELECT role FROM users WHERE id = auth.uid()) IN ('creator', 'admin')
  );

-- RLS Policy: Creators can update their own videos
CREATE POLICY "Creators can update own videos"
  ON videos FOR UPDATE
  USING (creator_id = auth.uid())
  WITH CHECK (creator_id = auth.uid());

-- RLS Policy: Admins can update any video
CREATE POLICY "Admins can update any video"
  ON videos FOR UPDATE
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin')
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- RLS Policy: Creators/Admins can delete their own videos
CREATE POLICY "Creators can delete own videos"
  ON videos FOR DELETE
  USING (creator_id = auth.uid() OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- ============================================================================
-- 3. EPISODES TABLE - Individual episodes/parts of videos
-- ============================================================================
CREATE TABLE IF NOT EXISTS episodes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  episode_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  thumbnail TEXT,
  video_url TEXT,
  duration INTEGER DEFAULT 0, -- in seconds
  views INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(video_id, episode_number)
);

-- Indexes
CREATE INDEX idx_episodes_video_id ON episodes(video_id);
CREATE INDEX idx_episodes_created_at ON episodes(created_at DESC);

-- Enable RLS on episodes table
ALTER TABLE episodes ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Anyone can read episodes of published videos
CREATE POLICY "Anyone can read episodes of published videos"
  ON episodes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM videos WHERE videos.id = episodes.video_id AND videos.status = 'Published'
    )
  );

-- RLS Policy: Creators can read episodes of their own videos
CREATE POLICY "Creators can read own video episodes"
  ON episodes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM videos WHERE videos.id = episodes.video_id AND videos.creator_id = auth.uid()
    )
  );

-- RLS Policy: Admins can read all episodes
CREATE POLICY "Admins can read all episodes"
  ON episodes FOR SELECT
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- RLS Policy: Creators can create episodes for their videos
CREATE POLICY "Creators can create episodes for own videos"
  ON episodes FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM videos WHERE videos.id = video_id AND videos.creator_id = auth.uid()
    )
  );

-- RLS Policy: Creators can update episodes of their videos
CREATE POLICY "Creators can update episodes of own videos"
  ON episodes FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM videos WHERE videos.id = video_id AND videos.creator_id = auth.uid()
    )
  );

-- ============================================================================
-- 4. SAVED_LIBRARY TABLE - User's saved videos
-- ============================================================================
CREATE TABLE IF NOT EXISTS saved_library (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  video_data JSONB NOT NULL, -- Snapshot of video metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, video_id)
);

-- Indexes
CREATE INDEX idx_saved_library_user_id ON saved_library(user_id);
CREATE INDEX idx_saved_library_created_at ON saved_library(created_at DESC);

-- Enable RLS on saved_library table
ALTER TABLE saved_library ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only read their own saved library
CREATE POLICY "Users can read own saved library"
  ON saved_library FOR SELECT
  USING (user_id = auth.uid());

-- RLS Policy: Users can only insert into their own saved library
CREATE POLICY "Users can save videos to own library"
  ON saved_library FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- RLS Policy: Users can only delete from their own saved library
CREATE POLICY "Users can remove from own saved library"
  ON saved_library FOR DELETE
  USING (user_id = auth.uid());

-- ============================================================================
-- 5. LIKES TABLE - Video likes tracking
-- ============================================================================
CREATE TABLE IF NOT EXISTS likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, video_id, COALESCE(episode_id, '00000000-0000-0000-0000-000000000000'))
);

-- Indexes
CREATE INDEX idx_likes_user_id ON likes(user_id);
CREATE INDEX idx_likes_video_id ON likes(video_id);
CREATE INDEX idx_likes_episode_id ON likes(episode_id);

-- Enable RLS on likes table
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Anyone can read likes count
CREATE POLICY "Anyone can read likes"
  ON likes FOR SELECT
  USING (true);

-- RLS Policy: Authenticated users can like videos
CREATE POLICY "Authenticated users can like videos"
  ON likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can unlike their own likes
CREATE POLICY "Users can unlike own videos"
  ON likes FOR DELETE
  USING (user_id = auth.uid());

-- ============================================================================
-- 6. COMMENTS TABLE - Video/Episode comments
-- ============================================================================
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_video_id ON comments(video_id);
CREATE INDEX idx_comments_episode_id ON comments(episode_id);
CREATE INDEX idx_comments_parent_id ON comments(parent_comment_id);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

-- Enable RLS on comments table
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Anyone can read comments
CREATE POLICY "Anyone can read comments"
  ON comments FOR SELECT
  USING (true);

-- RLS Policy: Authenticated users can comment
CREATE POLICY "Authenticated users can comment"
  ON comments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can edit their own comments
CREATE POLICY "Users can edit own comments"
  ON comments FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- RLS Policy: Users can delete their own comments
CREATE POLICY "Users can delete own comments"
  ON comments FOR DELETE
  USING (user_id = auth.uid());

-- ============================================================================
-- 7. VIDEO_REVIEWS TABLE - Admin review queue for content moderation
-- ============================================================================
CREATE TABLE IF NOT EXISTS video_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  reviewer_id UUID REFERENCES users(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'Pending', -- 'Pending', 'Approved', 'Rejected'
  notes TEXT,
  rejection_reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(video_id)
);

-- Indexes
CREATE INDEX idx_video_reviews_status ON video_reviews(status);
CREATE INDEX idx_video_reviews_reviewer_id ON video_reviews(reviewer_id);

-- Enable RLS on video_reviews table
ALTER TABLE video_reviews ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Only admins can read reviews
CREATE POLICY "Admins can read reviews"
  ON video_reviews FOR SELECT
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- RLS Policy: Only admins can create reviews
CREATE POLICY "Admins can create reviews"
  ON video_reviews FOR INSERT
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- RLS Policy: Only admins can update reviews
CREATE POLICY "Admins can update reviews"
  ON video_reviews FOR UPDATE
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin')
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- ============================================================================
-- 8. SEARCH_CACHE TABLE - Materialized search index
-- ============================================================================
CREATE TABLE IF NOT EXISTS search_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL UNIQUE REFERENCES videos(id) ON DELETE CASCADE,
  search_text TEXT NOT NULL, -- Denormalized searchable text
  category TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Full-text search index
CREATE INDEX idx_search_cache_text ON search_cache USING gin(to_tsvector('english', search_text));
CREATE INDEX idx_search_cache_category ON search_cache(category);

-- ============================================================================
-- 9. FUNCTION: Update search cache when video changes
-- ============================================================================
CREATE OR REPLACE FUNCTION update_search_cache()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO search_cache (video_id, search_text, category)
    VALUES (NEW.id, NEW.title || ' ' || COALESCE(NEW.description, '') || ' ' || COALESCE(NEW.creator_name, ''), NEW.category)
    ON CONFLICT (video_id) DO UPDATE SET
      search_text = NEW.title || ' ' || COALESCE(NEW.description, '') || ' ' || COALESCE(NEW.creator_name, ''),
      category = NEW.category;
  ELSIF TG_OP = 'DELETE' THEN
    DELETE FROM search_cache WHERE video_id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_search_cache
AFTER INSERT OR UPDATE OR DELETE ON videos
FOR EACH ROW
EXECUTE FUNCTION update_search_cache();

-- ============================================================================
-- 10. FUNCTION: Update video engagement counts (views, likes, comments)
-- ============================================================================
CREATE OR REPLACE FUNCTION update_video_engagement()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_TABLE_NAME = 'likes' THEN
    IF TG_OP = 'INSERT' THEN
      UPDATE videos SET likes_count = likes_count + 1 WHERE id = NEW.video_id;
    ELSIF TG_OP = 'DELETE' THEN
      UPDATE videos SET likes_count = GREATEST(likes_count - 1, 0) WHERE id = OLD.video_id;
    END IF;
  ELSIF TG_TABLE_NAME = 'comments' THEN
    IF TG_OP = 'INSERT' THEN
      UPDATE videos SET comments_count = comments_count + 1 WHERE id = NEW.video_id;
    ELSIF TG_OP = 'DELETE' THEN
      UPDATE videos SET comments_count = GREATEST(comments_count - 1, 0) WHERE id = OLD.video_id;
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_likes_count
AFTER INSERT OR DELETE ON likes
FOR EACH ROW
EXECUTE FUNCTION update_video_engagement();

CREATE TRIGGER trigger_update_comments_count
AFTER INSERT OR DELETE ON comments
FOR EACH ROW
EXECUTE FUNCTION update_video_engagement();

-- ============================================================================
-- 11. FUNCTION: Auto-update updated_at timestamps
-- ============================================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_users_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_update_videos_timestamp
BEFORE UPDATE ON videos
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_update_comments_timestamp
BEFORE UPDATE ON comments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- ============================================================================
-- SEED DATA (Optional - Remove for production)
-- ============================================================================
-- These are created by the app's fake_video_data.dart and seedVideosIfEmpty() method
