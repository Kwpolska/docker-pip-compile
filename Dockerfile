FROM python:3.15-alpine
WORKDIR /app
RUN apk add build-base libpq libpq-dev
RUN python -m venv /venv && /venv/bin/pip install --no-cache-dir pip-tools
CMD ["/venv/bin/pip-compile", "--strip-extras", "-U"]
