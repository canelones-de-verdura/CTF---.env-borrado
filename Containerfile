FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    ncat procps psmisc \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN useradd -m -s /bin/bash webapp && \
    useradd -m -s /bin/bash player

WORKDIR /opt/webapp
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .env ./
RUN chown -R webapp:webapp /opt/webapp

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

EXPOSE 1337

CMD ["/opt/entrypoint.sh"]
