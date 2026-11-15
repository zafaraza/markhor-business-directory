# Markhor Business Directory

A responsive Yellow-Pages-style community directory for Halton Region, Milton, Mississauga, Brampton, Kitchener, Cambridge, Guelph, Hamilton and the GTA.

## Included
- Responsive directory homepage and Markhor Cricket Club-inspired green/orange branding
- Supplied Markhor Business Directory brand artwork integrated into the homepage hero
- Search by business name/description, category and city
- Category shortcuts and featured/sponsored listing areas
- Business submission form
- Supabase database integration with pending/approved/rejected status
- Admin sign-in, approval/rejection, feature/sponsor toggles and unpublishing
- Row Level Security policies so visitors only see approved businesses

## Important: demo mode vs live mode
The site displays clearly labelled sample/demo businesses when no Supabase project is configured. In demo mode, the form does not send or store submissions. Connect Supabase to enable real submissions and admin management. Replace the sample listings in `app.js` with your own approved businesses before launch.

## 1. Create a Supabase project
1. Create a free project at https://supabase.com/.
2. Open **SQL Editor** and run the complete contents of `supabase-schema.sql`.
3. Open **Project Settings → API** and copy the Project URL and `anon` / publishable key.
4. Edit `config.js` and replace:
   - `YOUR_SUPABASE_PROJECT_URL`
   - `YOUR_SUPABASE_ANON_KEY`
5. Never put the `service_role` key in this website or commit it to GitHub.

## 2. Create your admin account
1. In Supabase, open **Authentication → Users** and create an admin user with an email and password.
2. Copy the user's UUID.
3. In SQL Editor run (replace the UUID):
   ```sql
   insert into public.admin_users (user_id)
   values ('YOUR-AUTH-USER-UUID');
   ```
4. Keep public user sign-ups disabled in Supabase Auth if you only want accounts you create to administer the directory.
5. Open the website and use the **Admin** link in the footer to sign in.

## 3. Test locally
Because the site loads Supabase's browser library, serve the folder using a local web server (rather than opening the HTML file directly). For example, if Python is installed:
```bash
cd markhor-business-directory
python -m http.server 8000
```
Then open http://localhost:8000.

## 4. Publish free with GitHub Pages
1. Create a GitHub repository, for example `markhor-business-directory`.
2. Upload `index.html`, `styles.css`, `app.js`, `config.js`, the `assets` folder, and (optionally) `README.md` and `supabase-schema.sql`.
3. In the repository, go to **Settings → Pages**.
4. Under **Build and deployment**, select **Deploy from a branch**.
5. Choose `main` and `/ (root)`, then Save.
6. Wait for the published URL shown in Settings → Pages.
7. Confirm your Supabase URL and anon key are configured in `config.js`, then test a submission and admin approval.

## 5. Before public launch
- Replace all demo/sample businesses with real businesses that have given permission to be listed.
- Replace placeholder phone numbers and descriptions.
- Add your real contact email, privacy policy and terms of use.
- Decide how you will verify listing ownership and handle removal/correction requests.
- Test the submission form, admin login, approval, search and mobile layout.
- Set up a custom domain if desired.

## Security and operational notes
- The browser `anon` key is designed to be public; the database Row Level Security policies are the security boundary.
- Never expose the Supabase `service_role` key.
- Admin actions require a Supabase Auth user whose UUID is in `admin_users`.
- The admin UI is intentionally simple. For a production business directory, consider adding CAPTCHA/rate limiting, email notifications, audit logs, image uploads, verified ownership and a privacy policy.
- Featured/sponsored flags are administrative controls only. This starter does not collect payments or automatically sell placements.
- The directory currently uses text-based initials rather than business logo uploads.
