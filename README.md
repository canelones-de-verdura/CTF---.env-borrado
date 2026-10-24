# Deleted .env

## Premisa

Son un hacker recontra picante y lograste obtener acceso al servidor de producción de una empresa.
Por desgracia para vos, los secretos están bien protegidos: una vez se cargan en la app se borra el .env inmediatamente.
O no?

## Cómo levantarlo

Después de clonar y `cd`ar el repo:

```bash
docker build -t ctf-deleted-env .
docker run --rm -p 1337:1337 ctf-deleted-env
```

Y desde otra terminal:

```bash
nc <ip_del_server> 1337
```

Cada tanto se rompe netcat con `Ncat: assertion failed: count <= INT_MAX QUITTING.` y rompe todo el container. Perdón.

**Por favor no hacer trampa y abrir el .env acá.**

**Abajo se sigue con las pistas y solución**

---

## Algunas pistas

1. Cuál es el bug en la app?
2. Dónde están los archivos que abre un proceso?


## Paso a paso

1. Al conectarse con netcat el jugador cae en un shell (bastante espartano, sin prompt, sin autocompletado, nada)
2. Si hace ls, va a ver que hay un `app.py`, y si lo investiga con `cat` va a ver la lógica que carga y borra el archivo, pero nunca lo cierra.
3. Como linux mantiene los file descriptors activos en `/proc/pid/fd`, primero hay hay que recuperar el PID de la app con `ps aux`.
4. Luego el jugador va a tener que cambiar de usuario con `su`, porque es "root" y el que ejecuta la app es "webapp".
5. Por último, `cat /proc/<pid>/fd/<n>`, donde <pid> es el recuperado en 3. y <n> es el file descriptor (seguramente 3. 0, 1 y 2 son stdin, out y err).

### Resumen

```bash
su webapp
ps aux
ls -l /proc/<PID>/fd
cat /proc/<PID>/fd/<N>
```
