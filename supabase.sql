-- 魔晶地牢：帳號雲端存檔 + 排行榜（在 Supabase 的 SQL Editor 執行一次）

create table if not exists public.saves (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.saves enable row level security;
drop policy if exists "saves_select_own" on public.saves;
drop policy if exists "saves_insert_own" on public.saves;
drop policy if exists "saves_update_own" on public.saves;
create policy "saves_select_own" on public.saves for select using (auth.uid() = user_id);
create policy "saves_insert_own" on public.saves for insert with check (auth.uid() = user_id);
create policy "saves_update_own" on public.saves for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.leaderboard (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  score bigint not null default 0,
  floor int not null default 0,
  kills int not null default 0,
  ch text,
  tt text default '',
  gd text default '',
  ts bigint not null default 0
);
alter table public.leaderboard enable row level security;
drop policy if exists "lb_read_all" on public.leaderboard;
drop policy if exists "lb_insert_own" on public.leaderboard;
drop policy if exists "lb_update_own" on public.leaderboard;
create policy "lb_read_all" on public.leaderboard for select using (true);
create policy "lb_insert_own" on public.leaderboard for insert with check (auth.uid() = user_id);
create policy "lb_update_own" on public.leaderboard for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index if not exists lb_score_idx on public.leaderboard (score desc);
