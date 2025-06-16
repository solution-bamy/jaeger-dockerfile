# Dockerfile específico para Jaeger no Railway
FROM jaegertracing/all-in-one:1.53

# Configurações para Railway
ENV COLLECTOR_OTLP_ENABLED=true
ENV SPAN_STORAGE_TYPE=memory
ENV JAEGER_DISABLED=false

# Expor portas
EXPOSE 16686 14268 6832 6831

# Railway precisa de um healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:16686/ || exit 1

CMD ["--collector.otlp.enabled=true"]
