## 🚀 Using This Repository

### **For Students**
```bash
# Clone the repository
git clone <repository-url>

# Explore available branches
git branch -a

# Checkout a specific week
git checkout week-02

# Install the app locally

1. python -m venv env #create a virtualenv
2. source env/bin/activate # activate the virtualenv
3. pip install -r requirements.txt # install the app locally
4. python app.py # this runs the app
```
# Your terminal should look like this

![Terminal view](images/screenshot-1.png)

# Navigate to 127.0.0.1:3000 in the browser, the app should render like this

![Browser view](images/screenshot-2.png)



## Automated EC2 deployment (Topic 7, Exercise 3)

Pushing to `week02` runs **Docker Build, Push, and Deploy**. The `build` job
publishes both `latest` and a commit tag for amd64 and arm64. Build date, commit,
and workflow run ID are embedded in the image and shown on the home page and
`/health`. The `deploy` job requires a successful build and uses AWS Systems
Manager `AWS-RunShellScript` to pull and restart `cs6620-app` on port `80:5000`
with `--restart unless-stopped`.

The repository needs `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`,
`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `AWS_REGION`,
and `EC2_INSTANCE_ID` in Actions secrets. Learner Lab's three temporary AWS
credential values must be refreshed after the lab session expires or restarts.
Never commit those values.

The target instance needs Docker, curl, Python 3, a running SSM agent, the lab
instance profile, outbound connectivity, and an existing inbound HTTP rule.
The workflow pulls `latest` as required by the exercise, then deploys the exact
build output by digest. It checks the image revision before replacing the
container, checks `/health` after startup, and waits for the SSM command to
finish. A successful `send-command` request alone does not pass deployment.

To verify on EC2 (substitute your Docker Hub username):

```sh
docker images --digests YOUR_USERNAME/cs6620-app
docker image inspect YOUR_USERNAME/cs6620-app:latest --format='{{json .Config.Labels}}' | python3 -m json.tool
docker ps --format '{{.Names}}\t{{.Status}}\t{{.CreatedAt}}'
docker logs --tail 15 cs6620-app
curl -fsS http://127.0.0.1/health
```

This single-instance stop/remove/run deployment has a short interruption while
the container restarts. It does not provide zero-downtime rollout or automatic
rollback.
