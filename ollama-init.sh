echo "Initializing Ollama with required models..."

echo "Waiting for Ollama service..."
until $(curl --output /dev/null --silent --fail http://ollama:11434/api/tags); do
  printf '.'
  sleep 5
done

echo "Ollama service is ready. Pulling models..."

curl -X POST http://ollama:11434/api/pull -d '{"name": "tinyllama"}'

echo "Ollama models initialized successfully!"