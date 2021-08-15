![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/hsteinshiromoto/docker.datascience/Docker/master?style=for-the-badge) ![Docker Image Version (latest semver)](https://img.shields.io/docker/v/hsteinshiromoto/docker.datascience?style=for-the-badge) ![Python Version](https://img.shields.io/badge/python-3-blue?style=for-the-badge)

# 1. Data Science Docker Container

# 2. Table of Contents

- [1. Data Science Docker Container](#1-data-science-docker-container)
- [2. Table of Contents](#2-table-of-contents)
- [3. Project Structure](#3-project-structure)

# 3. Project Structure
```
.
├── Dockerfile
├── Makefile
├── README.md
├── bin
│   ├── container.sh            <- Runs container
│   ├── entrypoint.sh           <- Sets up user ID in container as rootless
│   ├── setup.py            
│   ├── setup_python.sh         <- Install Python packages
│   └── test_environment.py
├── debian-requirements.txt     <- Necessary Debian packages
├── poetry.lock                 <- Environment dependencies
├── pyproject.toml              <- Environment main modules
└── requirements.txt
```
