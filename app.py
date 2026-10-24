from flask import Flask
import os

app = Flask(__name__)

env_path = "/opt/webapp/.env"
f = open(env_path)
for line in f:
    line = line.strip()
    if not line or line.startswith("#"):
        continue
    k, v = line.split("=", 1)
    os.environ[k] = v

os.remove(env_path)  # andá a leerlo

@app.route("/")
def index():
    return "Hola! Intentá sacar la flag!"

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
