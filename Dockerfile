FROM python:3.12.15-slim-trixie@sha256:2b4f19dae3a777dfc3b76730bda1e82e1f66ab2a2686fa93ca78edbfb4f04ffe

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -r appuser && \
	chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

# The whole context was copied to /app, so the app package lives in /app/app.
CMD ["sh", "-c", "gunicorn --chdir app --bind 0.0.0.0:${PORT:-8080} --workers 2 app:app"]
