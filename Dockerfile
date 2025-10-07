FROM quay.io/keycloak/keycloak:26.1.0 AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# Build Keycloak with development mode support
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.1.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Database configuration
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://10.112.61.91:5432/keycloak
ENV KC_DB_USERNAME=keycloak
ENV KC_DB_PASSWORD=keycloak

# Use local cache instead of distributed for testing
ENV KC_CACHE=local

# Logging configuration
ENV KC_LOG_LEVEL=INFO
ENV KC_LOG_CONSOLE_OUTPUT=json

# Host configuration
ENV KC_HOSTNAME=keycloak-pfe.onetech-group.corp
COPY keycloak-themes /opt/keycloak/themes/keycloak-themes
# Enable development mode (HTTP)
ENV KC_HTTP_ENABLED=true


# Add custom providers if needed
# COPY providers/* /opt/keycloak/providers/

EXPOSE 8080

# Start in development mode
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]
