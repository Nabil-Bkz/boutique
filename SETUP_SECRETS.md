# Quick Setup: GitHub Secrets for Deployment

## ⚠️ Deployment is Failing Because Secrets Are Missing

Your deployment workflow is failing because required GitHub secrets are not configured.

## ✅ Quick Fix (5 minutes)

### Step 1: Generate SSH Key (if you don't have one)

```bash
# Generate SSH key for GitHub Actions
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_key -N ""

# Display private key (copy everything including BEGIN and END lines)
cat ~/.ssh/github_actions_key
```

**Copy the entire output** - you'll need it for Step 2.

### Step 2: Add Public Key to Server

```bash
# Add public key to your server
ssh-copy-id -i ~/.ssh/github_actions_key.pub admin@35.180.255.192

# Test connection
ssh admin@35.180.255.192 "echo 'Connection successful!'"
```

### Step 3: Add GitHub Secrets

Go to: **https://github.com/Nabil-Bkz/boutique/settings/secrets/actions**

Click **"New repository secret"** for each:

#### Secret 1: SSH_PRIVATE_KEY
- **Name:** `SSH_PRIVATE_KEY`
- **Value:** Paste the private key from Step 1 (starts with `-----BEGIN OPENSSH PRIVATE KEY-----`)
- Click **"Add secret"**

#### Secret 2: SERVER_HOST
- **Name:** `SERVER_HOST`
- **Value:** `35.180.255.192` (or your server IP)
- Click **"Add secret"**

#### Secret 3: SERVER_USER
- **Name:** `SERVER_USER`
- **Value:** `admin`
- Click **"Add secret"**

### Step 4: Test Deployment

After adding secrets:

1. Go to: https://github.com/Nabil-Bkz/boutique/actions
2. Click **"Deploy to Server"** workflow
3. Click **"Run workflow"** (top right)
4. Click **"Run workflow"** button
5. Watch it deploy! 🚀

## 🔍 Verify Secrets Are Set

After adding secrets, you should see them listed at:
https://github.com/Nabil-Bkz/boutique/settings/secrets/actions

You should see:
- ✅ SSH_PRIVATE_KEY
- ✅ SERVER_HOST  
- ✅ SERVER_USER

## 📋 Alternative: Use Manual Workflow Input

If you don't want to set secrets, you can use manual workflow dispatch:

1. Go to: https://github.com/Nabil-Bkz/boutique/actions
2. Click **"Deploy to Server"**
3. Click **"Run workflow"**
4. Enter:
   - Server IP: `35.180.255.192`
   - SSH User: `admin`
5. Click **"Run workflow"**

**Note:** You still need `SSH_PRIVATE_KEY` secret for this to work.

## ❌ Common Mistakes

1. **Copying public key instead of private key**
   - ❌ Wrong: `~/.ssh/github_actions_key.pub`
   - ✅ Right: `~/.ssh/github_actions_key`

2. **Not copying the entire key**
   - Must include `-----BEGIN` and `-----END` lines

3. **Wrong secret names**
   - Must be exactly: `SSH_PRIVATE_KEY`, `SERVER_HOST`, `SERVER_USER`
   - Case-sensitive!

4. **Public key not on server**
   - Run: `ssh-copy-id -i ~/.ssh/github_actions_key.pub admin@35.180.255.192`

## ✅ Success Indicators

After setting up secrets correctly:

1. **Validation step passes:** "✅ Secrets validated"
2. **SSH connection works:** No permission denied errors
3. **Deployment succeeds:** Containers start on server
4. **Health checks pass:** Backend and frontend are accessible

## 🆘 Still Having Issues?

Check the workflow logs:
1. Go to: https://github.com/Nabil-Bkz/boutique/actions
2. Click on failed workflow run
3. Click on "deploy" job
4. Expand failed step to see error message

Common errors:
- `Permission denied` → Public key not on server
- `Connection refused` → Wrong server IP
- `Secret not found` → Secret name misspelled

See `TROUBLESHOOTING.md` for more help.

