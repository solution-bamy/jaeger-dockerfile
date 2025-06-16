# Dockerfile otimizado para Jaeger no Railway
FROM jaegertracing/all-in-one:1.53

# Instalar curl para healthcheck (Railway requirement)
USER root
RUN apk add --no-cache curl bash

# Copiar script de entrypoint
COPY jaeger-entrypoint.sh /usr/local/bin/jaeger-entrypoint.sh
RUN chmod +x /usr/local/bin/jaeger-entrypoint.sh

# Configurações de ambiente para Railway
ENV COLLECTOR_OTLP_ENABLED=true
ENV SPAN_STORAGE_TYPE=memory
ENV JAEGER_DISABLED=false

# Portas para Railway
EXPOSE 16686 14268 6832/udp 6831/udp 14269 9411

# Railway healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:${PORT:-16686}/api/services 2>/dev/null || curl -f http://localhost:16686/api/services || exit 1

# Usar o script de entrypoint que suporta a variável PORT do Railway
ENTRYPOINT ["/usr/local/bin/jaeger-entrypoint.sh"]
