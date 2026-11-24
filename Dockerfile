# SiftGate on Railway: upstream seanbabalala/SiftGate v2.14.0 (MIT), built with upstream's own Dockerfile
# (upstream publishes no image). Application unmodified. The GHCR workflow builds upstream at tag v2.14.0 as
# the base, then this layer adds railway/start.sh: on first boot it writes /app/data/gateway.config.yaml (on the
# volume) from upstream's example config with port 8080, trust_proxy on and dashboard.password taken from
# SIFTGATE_DASHBOARD_PASSWORD (SiftGate hashes it with bcrypt and writes the hash back on startup).
ARG BASE=siftgate-upstream:v2.14.0
FROM ${BASE}
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/siftgate"
COPY railway/start.sh /railway-start.sh
USER root
RUN chmod +x /railway-start.sh
ENV NODE_ENV=production \
    SIFTGATE_HOST=0.0.0.0 \
    GATEWAY_CONFIG_PATH=/app/data/gateway.config.yaml \
    SIFTGATE_WATCHDOG_ALERTS_PATH=/app/data/alert-connectors.json \
    SIFTGATE_HEALTHCHECK_PORT=8080
EXPOSE 8080
CMD ["/railway-start.sh"]
