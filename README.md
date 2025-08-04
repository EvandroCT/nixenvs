## Steps followed to create this environment

The instructions below contain both the imputed commands and their respective outputs to stdout (and stderr). They serve as documentation on how this environment was derived, as well as a template to devise new ones, but not to reproduce the exact same available in this directory.

⚠ **Beware** ⚠ The workflow covered here doesn't follow a purely functional derivation process, meaning you may ultimately not having the same environment. If you rely on it, please, clone this repository and issue your commands using the `devenv shell` tool to confidently yield the very same outcome, no matter where you live, whoever you are or whatever you do 😉.

### ✅ Step 1
-------------

|  Description| Record the hash of the [template's⬈](https://github.com/clementpoiret/nix-python-devenv) last main commit.|
|------------:|:----------------------------------------------------------------------------------------------------------|
|           🧑🏻‍💻|`gh api repos/clementpoiret/nix-python-devenv/commits/main --jq .sha`                                      |
|    🖵 output| d05b105aea35c14ea634a9c35c08cf07aa500db7                                                                  |


### ✅ Step 2
-------------

|  Description| Fork the [clementpoiret/nix-python-devenv⬈](https://github.com/clementpoiret/nix-python-devenv) template and clone it.|
|------------:|:----------------------------------------------------------------------------------------------------------------------|
|           🧑🏻‍💻|`gh repo fork clementpoiret/nix-python-devenv --fork-name=nixenvs --clone -- mission1-env`                             |
|    🖵 output| 👇🏼👇🏼👇🏼                                                                                                                |

```gh
✓ Created fork EvandroCT/nixenvs
Cloning into 'mission1-env'...
remote: Enumerating objects: 55, done.
remote: Counting objects: 100% (55/55), done.
remote: Compressing objects: 100% (39/39), done.
remote: Total 55 (delta 22), reused 42 (delta 13), pack-reused 0 (from 0)
Receiving objects: 100% (55/55), 39.65 KiB | 2.48 MiB/s, done.
Resolving deltas: 100% (22/22), done.
From https://github.com/clementpoiret/nix-python-devenv
 * [new branch]      cuda       -> upstream/cuda
 * [new branch]      main       -> upstream/main
✓ Cloned fork
! Repository clementpoiret/nix-python-devenv set as the default repository. To learn more about the default repository, run: gh repo set-default --help
```

### ✅ Step 3
-------------

|  Description| Get into the local repo, create the _mission1-env_ branch and push it to remote.   |
|------------:|:-----------------------------------------------------------------------------------|
|           🧑🏻‍💻|`cd mission1-env && git checkout -b mission1-env && git push -u origin mission1-env`|
|    🖵 output| 👇🏼👇🏼👇🏼                                                                             | 

```git
Switched to a new branch 'mission1-env'
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
remote: 
remote: Create a pull request for 'mission1-env' on GitHub by visiting:
remote:      https://github.com/EvandroCT/nixenvs/pull/new/mission1-env
remote: 
To https://github.com/EvandroCT/nixenvs.git
 * [new branch]      mission1-env -> mission1-env
branch 'mission1-env' set up to track 'origin/mission1-env'.
```

### ✅ Step 4
-------------

|  Description| Clean up unnecessary files.|
|------------:|:-----------------------------------------------------------|
|           🧑🏻‍💻|`rm -rf .envrc .python-version devenv.lock hello.py uv.lock`|
|    🖵 output|                                                            |

### ✅ Step 5
-------------

|  Description| Edit [./devenv.nix 📝](devenv.nix) to remove the broken reference to the deleted file *hello.py*.|
|------------:|:-------------------------------------------------------------------------------------------------|
|           🧑🏻‍💻| Run `git diff devenv.nix` to see undertook editions.                                             |
|    🖵 output| 👇🏼👇🏼👇🏼                                                                                           |

```diff
diff --git a/devenv.nix b/devenv.nix
index 5bfedfb..ef82bcc 100644
--- a/devenv.nix
+++ b/devenv.nix
@@ -23,10 +23,7 @@ in
     };
   };
 
-  scripts.hello.exec = "uv run python hello.py";
-
   enterShell = ''
     . .devenv/state/venv/bin/activate
-    hello
   '';
 }
 ```

### ✅ Step 6
-------------

|  Description| Edit [./pyproject.toml 📝](pyproject.toml) to set project's dependencies and metadata.|
|------------:|:--------------------------------------------------------------------------------------|
|           🧑🏻‍💻| Run `git diff pyproject.toml` to see undertook editions.                              |
|    🖵 output| 👇🏼👇🏼👇🏼                                                                                |

```diff
diff --git a/pyproject.toml b/pyproject.toml
index b6d7ebb..3a4c25c 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -1,9 +1,10 @@
 [project]
-name = "nix-python-devenv"
+name = "mission1-env"
 version = "0.1.0"
-description = "Example project with working C bindings!"
+description = "Mission 1 environment."
 readme = "README.md"
-requires-python = ">=3.11"
+requires-python = ">=3.12"
 dependencies = [
-    "numpy>=2.1.2",
+    "earthengine-api",
+    "geopandas"
 ]
 ```

### ✅ Step 7
-------------

|  Description| Create the _devenv_ and _uv_ locks.|
|------------:|:-----------------------------------|
|           🧑🏻‍💻|`devenv shell uv -- sync`           |
|    🖵 output| 👇🏼👇🏼👇🏼                             |

```devenv
warning: creating lock file "/tmp/mission1-env/devenv.lock": 
• Added input 'devenv':
    'github:cachix/devenv/062f3f42de2f6bb7382f88f6dbcbbbaa118a3791?dir=src/modules' (2025-08-02)
• Added input 'git-hooks':
    'github:cachix/git-hooks.nix/16ec914f6fb6f599ce988427d9d94efddf25fe6d' (2025-06-24)
• Added input 'git-hooks/flake-compat':
    'github:edolstra/flake-compat/9100a0f413b0c601e0533d1d94ffd501ce2e7885' (2025-05-12)
• Added input 'git-hooks/gitignore':
    'github:hercules-ci/gitignore.nix/637db329424fd7e46cf4185293b9cc8c88c95394' (2024-02-28)
• Added input 'git-hooks/gitignore/nixpkgs':
    follows 'git-hooks/nixpkgs'
• Added input 'git-hooks/nixpkgs':
    follows 'nixpkgs'
• Added input 'nixpkgs':
    'github:NixOS/nixpkgs/bf9fa86a9b1005d932f842edf2c38eeecc98eef3' (2025-08-03)
• Added input 'pre-commit-hooks':
    follows 'git-hooks'
• Using Cachix caches: devenv
✓ Building shell in 19.7s
• Entering shell
Running tasks     devenv:enterShell

Failed            devenv:python:uv                         562ms     
Dependency failed devenv:enterShell                                  
1 Failed, 1 Dependency Failed       563.15ms

--- devenv:python:uv failed with error: Task exited with status: exit status: 1
--- devenv:python:uv stdout:
0000.56: /tmp/mission1-env /tmp/mission1-env
--- devenv:python:uv stderr:
0000.42: Using CPython 3.13.5 interpreter at: /nix/store/nrmg3yj9f61p57c3vkz8smcvbvn82c13-python3-3.13.5-env/bin/python3
0000.42: Creating virtual environment at: .devenv/state/venv
0000.00: error: Unable to find lockfile at `uv.lock`. To create a lockfile, run `uv lock` or `uv sync`.
0000.00: uv sync failed. Run 'uv sync' manually.
---

Resolved 36 packages in 110ms
Prepared 2 packages in 155ms
Installed 35 packages in 449ms
 + cachetools==5.5.2
 + certifi==2025.8.3
 + charset-normalizer==3.4.2
 + earthengine-api==1.6.1
 + geopandas==1.1.1
 + google-api-core==2.25.1
 + google-api-python-client==2.177.0
 + google-auth==2.40.3
 + google-auth-httplib2==0.2.0
 + google-cloud-core==2.4.3
 + google-cloud-storage==3.2.0
 + google-crc32c==1.7.1
 + google-resumable-media==2.7.2
 + googleapis-common-protos==1.70.0
 + httplib2==0.22.0
 + idna==3.10
 + numpy==2.3.2
 + packaging==25.0
 + pandas==2.3.1
 + proto-plus==1.26.1
 + protobuf==6.31.1
 + pyasn1==0.6.1
 + pyasn1-modules==0.4.2
 + pyogrio==0.11.1
 + pyparsing==3.2.3
 + pyproj==3.7.1
 + python-dateutil==2.9.0.post0
 + pytz==2025.2
 + requests==2.32.4
 + rsa==4.9.1
 + shapely==2.1.1
 + six==1.17.0
 + tzdata==2025.2
 + uritemplate==4.2.0
 + urllib3==2.5.0
 ```

### ✅ Step 8
-------------

|  Description| Testing the new environment.                                        |
|------------:|:--------------------------------------------------------------------|
|           🧑🏻‍💻|`devenv shell python -- -c 'import ee, geopandas; print("Success!")'`|
|    🖵 output| 👇🏼👇🏼👇🏼                                                              |

```devenv
• Using Cachix caches: devenv
✓ Building shell in 113ms
• Entering shell
Running tasks     devenv:enterShell

Succeeded         devenv:python:uv                         85ms      
Succeeded         devenv:enterShell                        6ms       
2 Succeeded                         99.46ms
Success!
```