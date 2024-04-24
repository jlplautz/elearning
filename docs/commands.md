## Dumpdata  command dumps data from the database into the standard output, 
## serialized in JSON format by default
```cmd
❯ mng dumpdata courses --indent=2
[
{
  "model": "courses.subject",
  "pk": 1,
  "fields": {
    "title": "Matemática",
    "slug": "matematica"
  }
},
{
  "model": "courses.subject",
  "pk": 2,
  "fields": {
    "title": "Musica",
    "slug": "musica"
  }
},
{
  "model": "courses.subject",
  "pk": 3,
  "fields": {
    "title": "Física",
    "slug": "fisica"
  }
},
{
  "model": "courses.subject",
  "pk": 4,
  "fields": {
    "title": "Programação",
    "slug": "programacao"
  }
}
]
```

## Com o comando dumpdata podemos fazer backup  do modelo de dados e carregar novamente
 - backup
 ```cmd
 ❯ python manage.py dumpdata courses --indent=2 --output=educa/courses/fixtures/subjects.json      
[...........................................................................]
```
- Restore

### By default, Django looks for files in the fixtures/ directory of each application, but you can specify the complete path to the fixture file for the loaddata command. 
```cmd
❯ python manage.py loaddata subjects.json                                                       
Installed 4 object(s) from 1 fixture(s)
```

## Criar um novo curso via shell
```cmd
❯ mng shell            
Python 3.12.2 (main, Apr 11 2024, 03:48:40) [GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> from django.contrib.auth.models import User
>>> from educa.courses.models import Subject, Course, Module
>>> user = User.objects.last()
>>> subject = Subject.objects.last()
>>> curso1 = Course.objects.create(subject=subject, owner=user, title='Course 1', slug='course1')
>>> m1 = Module.objects.create(course=curso1, title='Module 1')
>>> m1.order
0
>>> m2 = Module.objects.create(course=curso1, title='Module 2')
>>> m2.order
1
>>> m3 = Module.objects.create(course=curso1, title='Module 3')
>>> m3.order
2
```


## 1- Using the Redis cache backend

```
pip install redis==4.3.4
Collecting redis==4.3.4
  Downloading redis-4.3.4-py3-none-any.whl.metadata (53 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.9/53.9 kB 986.5 kB/s eta 0:00:00
Collecting deprecated>=1.2.3 (from redis==4.3.4)
  Downloading Deprecated-1.2.14-py2.py3-none-any.whl.metadata (5.4 kB)
Collecting packaging>=20.4 (from redis==4.3.4)
  Downloading packaging-24.0-py3-none-any.whl.metadata (3.2 kB)
Collecting async-timeout>=4.0.2 (from redis==4.3.4)
  Downloading async_timeout-4.0.3-py3-none-any.whl.metadata (4.2 kB)
Collecting wrapt<2,>=1.10 (from deprecated>=1.2.3->redis==4.3.4)
  Downloading wrapt-1.16.0-cp311-cp311-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (6.6 kB)
Downloading redis-4.3.4-py3-none-any.whl (246 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 246.2/246.2 kB 1.2 MB/s eta 0:00:00
Downloading async_timeout-4.0.3-py3-none-any.whl (5.7 kB)
Downloading Deprecated-1.2.14-py2.py3-none-any.whl (9.6 kB)
Downloading packaging-24.0-py3-none-any.whl (53 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.5/53.5 kB 2.3 MB/s eta 0:00:00
Downloading wrapt-1.16.0-cp311-cp311-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (80 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 80.7/80.7 kB 1.0 MB/s eta 0:00:00
Installing collected packages: wrapt, packaging, async-timeout, deprecated, redis
Successfully installed async-timeout-4.0.3 deprecated-1.2.14 packaging-24.0 redis-4.3.4 wrapt-1.16.0
```

##2- the settings.py file of the educa project and modify the CACHES setting, as follows

```cmd
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': 'redis://127.0.0.1:6379',
    }
}
```

##3- executar o redis
```cmd
docker run -it --rm --name redis -p 6379:6379 redis
Unable to find image 'redis:latest' locally
latest: Pulling from library/redis
13808c22b207: Already exists 
6900ab66c9ff: Pull complete 
d707ec7ebe0f: Pull complete 
031016405bfb: Pull complete 
84b54dfd90f6: Pull complete 
6d2bba2ab923: Pull complete 
4f4fb700ef54: Pull complete 
09073cda9bdf: Pull complete 
Digest: sha256:1d38c52e8d34c0471350c545d7a9066c95f5a6b9f24c74209331c03c496e2290
Status: Downloaded newer image for redis:latest
1:C 12 Apr 2024 20:14:06.092 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. Being disabled, it can also cause failures without low memory condition, see https://github.com/jemalloc/jemalloc/issues/1328. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
1:C 12 Apr 2024 20:14:06.092 * oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 12 Apr 2024 20:14:06.092 * Redis version=7.2.4, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 12 Apr 2024 20:14:06.092 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
1:M 12 Apr 2024 20:14:06.093 * monotonic clock: POSIX clock_gettime
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 7.2.4 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                  
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           https://redis.io       
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

1:M 12 Apr 2024 20:14:06.094 * Server initialized
1:M 12 Apr 2024 20:14:06.094 * Ready to accept connections tcp
```

##4- Monitoring Redis with Django Redisboard
```cmd
pip install django-redisboard==8.3.0
pip install attrs
```

##5- run Django Redisboard migrations
```cmd
python manage.py migrate redisboard
Operations to perform:
  Apply all migrations: redisboard
Running migrations:
  Applying redisboard.0001_initial... OK
  Applying redisboard.0002_add_url... OK
  Applying redisboard.0003_fill_url... OK
  Applying redisboard.0004_cleanup... OK
  Applying redisboard.0005_config... OK
```

## to setting the environment as localenv 
```cmd
❯ python manage.py runserver --settings=educa.settings.local
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
April 12, 2024 - 22:06:00
Django version 5.0.4, using settings 'educa.settings.local'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.

❯ env | grep DJANGO_SETTINGS_MODULE                 
DJANGO_SETTINGS_MODULE=educa.settings.local

```

## docker compose up -> concluio com sucesso

```cmd
❯ docker compose up
[+] Running 4/0
 ✔ Container elearning-nginx-1  Created                                                                                                                      0.0s 
 ✔ Container elearning-db-1     Created                                                                                                                      0.0s 
 ✔ Container elearning-cache-1  Created                                                                                                                      0.0s 
 ✔ Container elearning-web-1    Created                                                                                                                      0.0s 
Attaching to elearning-cache-1, elearning-db-1, elearning-nginx-1, elearning-web-1
elearning-cache-1  | 1:C 17 Apr 2024 00:18:37.167 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
elearning-cache-1  | 1:C 17 Apr 2024 00:18:37.167 # Redis version=7.0.4, bits=64, commit=00000000, modified=0, pid=1, just started
elearning-cache-1  | 1:C 17 Apr 2024 00:18:37.167 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.168 * monotonic clock: POSIX clock_gettime
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.172 * Running mode=standalone, port=6379.
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 # Server initialized
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 * Loading RDB produced by version 7.0.4
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 * RDB age 20 seconds
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 * RDB memory usage when created 0.82 Mb
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 * Done loading RDB, keys loaded: 0, keys expired: 0.
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 * DB loaded from disk: 0.000 seconds
elearning-cache-1  | 1:M 17 Apr 2024 00:18:37.173 * Ready to accept connections
elearning-nginx-1  | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
elearning-nginx-1  | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
elearning-nginx-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
elearning-nginx-1  | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
elearning-nginx-1  | 10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf differs from the packaged version
elearning-nginx-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
elearning-nginx-1  | 20-envsubst-on-templates.sh: Running envsubst on /etc/nginx/templates/default.conf.template to /etc/nginx/conf.d/default.conf
elearning-nginx-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
elearning-nginx-1  | /docker-entrypoint.sh: Configuration complete; ready for start up
elearning-nginx-1  | 2024/04/17 00:18:37 [warn] 1#1: conflicting server name "www.educaproject.com" on 0.0.0.0:80, ignored
elearning-nginx-1  | nginx: [warn] conflicting server name "www.educaproject.com" on 0.0.0.0:80, ignored
elearning-nginx-1  | 2024/04/17 00:18:37 [warn] 1#1: conflicting server name "educaproject.com" on 0.0.0.0:80, ignored
elearning-nginx-1  | nginx: [warn] conflicting server name "educaproject.com" on 0.0.0.0:80, ignored
elearning-nginx-1  | 2024/04/17 00:18:37 [warn] 1#1: conflicting server name "localhost" on 0.0.0.0:80, ignored
elearning-nginx-1  | nginx: [warn] conflicting server name "localhost" on 0.0.0.0:80, ignored
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: using the "epoll" event method
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: nginx/1.23.1
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6) 
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: OS: Linux 5.4.0-176-generic
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: start worker processes
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: start worker process 34
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: start worker process 35
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: start worker process 36
elearning-nginx-1  | 2024/04/17 00:18:37 [notice] 1#1: start worker process 37
elearning-db-1     | 
elearning-db-1     | PostgreSQL Database directory appears to contain a database; Skipping initialization
elearning-db-1     | 
elearning-db-1     | 
elearning-db-1     | 2024-04-17 00:18:37.593 UTC [1] LOG:  starting PostgreSQL 16.2 (Debian 16.2-1.pgdg120+2) on x86_64-pc-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit
elearning-db-1     | 2024-04-17 00:18:37.593 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
elearning-db-1     | 2024-04-17 00:18:37.593 UTC [1] LOG:  listening on IPv6 address "::", port 5432
elearning-db-1     | 2024-04-17 00:18:37.599 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
elearning-db-1     | 2024-04-17 00:18:37.607 UTC [29] LOG:  database system was shut down at 2024-04-17 00:18:17 UTC
elearning-db-1     | 2024-04-17 00:18:37.623 UTC [1] LOG:  database system is ready to accept connections
elearning-web-1    | wait-for-it.sh: waiting 15 seconds for db:5432
elearning-web-1    | wait-for-it.sh: db:5432 is available after 0 seconds
elearning-web-1    | [uWSGI] getting INI configuration from /code/config/uwsgi/uwsgi.ini
elearning-web-1    | *** Starting uWSGI 2.0.20 (64bit) on [Wed Apr 17 00:18:38 2024] ***
elearning-web-1    | compiled with version: 10.2.1 20210110 on 16 April 2024 23:47:14
elearning-web-1    | os: Linux-5.4.0-176-generic #196-Ubuntu SMP Fri Mar 22 16:46:39 UTC 2024
elearning-web-1    | nodename: 6be8fa51779c
elearning-web-1    | machine: x86_64
elearning-web-1    | clock source: unix
elearning-web-1    | pcre jit disabled
elearning-web-1    | detected number of CPU cores: 4
elearning-web-1    | current working directory: /code
elearning-web-1    | detected binary path: /usr/local/bin/uwsgi
elearning-web-1    | *** WARNING: you are running uWSGI as root !!! (use the --uid flag) *** 
elearning-web-1    | chdir() to /code
elearning-web-1    | your memory page size is 4096 bytes
elearning-web-1    | detected max file descriptor number: 1048576
elearning-web-1    | lock engine: pthread robust mutexes
elearning-web-1    | thunder lock: disabled (you can enable it with --thunder-lock)
elearning-web-1    | uwsgi socket 0 bound to UNIX address /code/educa/uwsgi_app.sock fd 3
elearning-web-1    | *** WARNING: you are running uWSGI as root !!! (use the --uid flag) *** 
elearning-web-1    | Python version: 3.10.6 (main, Aug 23 2022, 08:25:41) [GCC 10.2.1 20210110]
elearning-web-1    | *** Python threads support is disabled. You can enable it with --enable-threads ***
elearning-web-1    | Python main interpreter initialized at 0x5565be679650
elearning-web-1    | *** WARNING: you are running uWSGI as root !!! (use the --uid flag) *** 
elearning-web-1    | your server socket listen backlog is limited to 100 connections
elearning-web-1    | your mercy for graceful operations on workers is 60 seconds
elearning-web-1    | mapped 145840 bytes (142 KB) for 1 cores
elearning-web-1    | *** Operational MODE: single process ***
elearning-web-1    | WSGI app 0 (mountpoint='') ready in 4 seconds on interpreter 0x5565be679650 pid: 1 (default app)
elearning-web-1    | *** WARNING: you are running uWSGI as root !!! (use the --uid flag) *** 
elearning-web-1    | *** uWSGI is running in multiple interpreter mode ***
elearning-web-1    | spawned uWSGI master process (pid: 1)
elearning-web-1    | spawned uWSGI worker 1 (pid: 18, cores: 1)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:00 +0000] "GET /admin HTTP/1.1" 301 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 1/1] 172.24.0.1 () {58 vars in 1105 bytes} [Wed Apr 17 00:19:00 2024] GET /admin => generated 0 bytes in 95 msecs (HTTP/1.1 301) 6 headers in 216 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:00 +0000] "GET /admin/ HTTP/1.1" 302 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 2/2] 172.24.0.1 () {58 vars in 1107 bytes} [Wed Apr 17 00:19:00 2024] GET /admin/ => generated 0 bytes in 106 msecs (HTTP/1.1 302) 10 headers in 372 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:00 +0000] "GET /admin/login/?next=/admin/ HTTP/1.1" 200 2218 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 3/3] 172.24.0.1 () {58 vars in 1144 bytes} [Wed Apr 17 00:19:00 2024] GET /admin/login/?next=/admin/ => generated 2218 bytes in 144 msecs (HTTP/1.1 200) 10 headers in 470 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/base.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 4/4] 172.24.0.1 () {54 vars in 998 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/base.css => generated 179 bytes in 7 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/dark_mode.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 5/5] 172.24.0.1 () {54 vars in 1008 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/dark_mode.css => generated 179 bytes in 7 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/nav_sidebar.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 6/6] 172.24.0.1 () {54 vars in 1012 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/nav_sidebar.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 7/7] 172.24.0.1 () {54 vars in 1000 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/login.css => generated 179 bytes in 4 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/login.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 8/8] 172.24.0.1 () {54 vars in 1010 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/responsive.css => generated 179 bytes in 9 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/responsive.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 9/9] 172.24.0.1 () {54 vars in 994 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/js/nav_sidebar.js => generated 179 bytes in 5 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/js/nav_sidebar.js HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/base.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 10/10] 172.24.0.1 () {54 vars in 998 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 11/11] 172.24.0.1 () {54 vars in 1008 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/dark_mode.css => generated 179 bytes in 4 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/dark_mode.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/nav_sidebar.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 12/12] 172.24.0.1 () {54 vars in 1012 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/nav_sidebar.css => generated 179 bytes in 4 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:01 +0000] "GET /static/admin/css/login.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 13/13] 172.24.0.1 () {54 vars in 1000 bytes} [Wed Apr 17 00:19:01 2024] GET /static/admin/css/login.css => generated 179 bytes in 4 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-db-1     | 2024-04-17 00:19:08.515 UTC [35] ERROR:  relation "auth_user" does not exist at character 280
elearning-db-1     | 2024-04-17 00:19:08.515 UTC [35] STATEMENT:  SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."username" = 'jlplautz' LIMIT 21
elearning-db-1     | 2024-04-17 00:19:08.567 UTC [35] ERROR:  relation "auth_user" does not exist at character 280
elearning-db-1     | 2024-04-17 00:19:08.567 UTC [35] STATEMENT:  SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" LIMIT 21
elearning-db-1     | 2024-04-17 00:19:08.569 UTC [35] ERROR:  relation "auth_user" does not exist at character 280
elearning-db-1     | 2024-04-17 00:19:08.569 UTC [35] STATEMENT:  SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."username" = 'jlplautz' LIMIT 21
elearning-db-1     | 2024-04-17 00:19:08.571 UTC [35] ERROR:  relation "auth_user" does not exist at character 280
elearning-db-1     | 2024-04-17 00:19:08.571 UTC [35] STATEMENT:  SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."username" = 'jlplautz' LIMIT 21
elearning-db-1     | 2024-04-17 00:19:08.572 UTC [35] ERROR:  relation "auth_user" does not exist at character 280
elearning-db-1     | 2024-04-17 00:19:08.572 UTC [35] STATEMENT:  SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."username" = 'jlplautz' LIMIT 21
elearning-db-1     | 2024-04-17 00:19:08.574 UTC [35] ERROR:  relation "auth_user" does not exist at character 280
elearning-db-1     | 2024-04-17 00:19:08.574 UTC [35] STATEMENT:  SELECT "auth_user"."id", "auth_user"."password", "auth_user"."last_login", "auth_user"."is_superuser", "auth_user"."username", "auth_user"."first_name", "auth_user"."last_name", "auth_user"."email", "auth_user"."is_staff", "auth_user"."is_active", "auth_user"."date_joined" FROM "auth_user" WHERE "auth_user"."username" = 'jlplautz' LIMIT 21
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:19:08 +0000] "POST /admin/login/?next=/admin/ HTTP/1.1" 500 145 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 14/14] 172.24.0.1 () {66 vars in 1357 bytes} [Wed Apr 17 00:19:08 2024] POST /admin/login/?next=/admin/ => generated 145 bytes in 238 msecs (HTTP/1.1 500) 7 headers in 240 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 15/15] 172.24.0.1 () {56 vars in 1113 bytes} [Wed Apr 17 00:22:05 2024] GET /admin/login/?next=/admin/ => generated 2218 bytes in 33 msecs (HTTP/1.1 200) 10 headers in 470 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /admin/login/?next=/admin/ HTTP/1.1" 200 2218 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 16/16] 172.24.0.1 () {54 vars in 998 bytes} [Wed Apr 17 00:22:05 2024] GET /static/admin/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /static/admin/css/base.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 17/17] 172.24.0.1 () {54 vars in 1008 bytes} [Wed Apr 17 00:22:05 2024] GET /static/admin/css/dark_mode.css => generated 179 bytes in 6 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /static/admin/css/dark_mode.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 18/18] 172.24.0.1 () {54 vars in 1012 bytes} [Wed Apr 17 00:22:05 2024] GET /static/admin/css/nav_sidebar.css => generated 179 bytes in 3 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /static/admin/css/nav_sidebar.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /static/admin/css/login.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 19/19] 172.24.0.1 () {54 vars in 1000 bytes} [Wed Apr 17 00:22:05 2024] GET /static/admin/css/login.css => generated 179 bytes in 3 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /static/admin/css/responsive.css HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 20/20] 172.24.0.1 () {54 vars in 1010 bytes} [Wed Apr 17 00:22:05 2024] GET /static/admin/css/responsive.css => generated 179 bytes in 6 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 21/21] 172.24.0.1 () {54 vars in 994 bytes} [Wed Apr 17 00:22:05 2024] GET /static/admin/js/nav_sidebar.js => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:05 +0000] "GET /static/admin/js/nav_sidebar.js HTTP/1.1" 404 179 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "POST /admin/login/?next=/admin/ HTTP/1.1" 302 0 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 22/22] 172.24.0.1 () {66 vars in 1357 bytes} [Wed Apr 17 00:22:08 2024] POST /admin/login/?next=/admin/ => generated 0 bytes in 554 msecs (HTTP/1.1 302) 12 headers in 634 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /admin/ HTTP/1.1" 200 5368 "http://localhost/admin/login/?next=/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 23/23] 172.24.0.1 () {60 vars in 1216 bytes} [Wed Apr 17 00:22:08 2024] GET /admin/ => generated 5368 bytes in 118 msecs (HTTP/1.1 200) 10 headers in 470 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/base.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 24/24] 172.24.0.1 () {54 vars in 1023 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 25/25] 172.24.0.1 () {54 vars in 1033 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/dark_mode.css => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/dark_mode.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 26/26] 172.24.0.1 () {54 vars in 1037 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/nav_sidebar.css => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/nav_sidebar.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 27/27] 172.24.0.1 () {54 vars in 1033 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/dashboard.css => generated 179 bytes in 4 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/dashboard.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 28/28] 172.24.0.1 () {54 vars in 1035 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/responsive.css => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/responsive.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 29/29] 172.24.0.1 () {54 vars in 1019 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/js/nav_sidebar.js => generated 179 bytes in 5 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/js/nav_sidebar.js HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/base.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 30/30] 172.24.0.1 () {54 vars in 1023 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/dark_mode.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 31/31] 172.24.0.1 () {54 vars in 1033 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/dark_mode.css => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 32/32] 172.24.0.1 () {54 vars in 1037 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/nav_sidebar.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/nav_sidebar.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/dashboard.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 33/33] 172.24.0.1 () {54 vars in 1033 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/dashboard.css => generated 179 bytes in 3 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:22:08 +0000] "GET /static/admin/css/responsive.css HTTP/1.1" 404 179 "http://localhost/admin/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 34/34] 172.24.0.1 () {54 vars in 1035 bytes} [Wed Apr 17 00:22:08 2024] GET /static/admin/css/responsive.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-db-1     | 2024-04-17 00:23:37.704 UTC [27] LOG:  checkpoint starting: time
elearning-db-1     | 2024-04-17 00:23:57.823 UTC [27] LOG:  checkpoint complete: wrote 202 buffers (1.2%); 0 WAL file(s) added, 0 removed, 0 recycled; write=20.058 s, sync=0.046 s, total=20.120 s; sync files=167, longest=0.033 s, average=0.001 s; distance=954 kB, estimate=954 kB; lsn=0/161B150, redo lsn=0/161B118
elearning-web-1    | [pid: 18|app: 0|req: 35/35] 172.24.0.1 () {56 vars in 1130 bytes} [Wed Apr 17 00:32:12 2024] GET /course/mine => generated 0 bytes in 1 msecs (HTTP/1.1 301) 6 headers in 222 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:12 +0000] "GET /course/mine HTTP/1.1" 301 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:12 +0000] "GET /course/mine/ HTTP/1.1" 200 1120 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 36/36] 172.24.0.1 () {56 vars in 1132 bytes} [Wed Apr 17 00:32:12 2024] GET /course/mine/ => generated 1120 bytes in 52 msecs (HTTP/1.1 200) 8 headers in 358 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:12 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/mine/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 37/37] 172.24.0.1 () {54 vars in 1017 bytes} [Wed Apr 17 00:32:12 2024] GET /static/css/base.css => generated 179 bytes in 4 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:12 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/mine/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 38/38] 172.24.0.1 () {54 vars in 1017 bytes} [Wed Apr 17 00:32:12 2024] GET /static/css/base.css => generated 179 bytes in 5 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:22 +0000] "GET /course/create/ HTTP/1.1" 200 1911 "http://localhost/course/mine/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 39/39] 172.24.0.1 () {58 vars in 1188 bytes} [Wed Apr 17 00:32:22 2024] GET /course/create/ => generated 1911 bytes in 81 msecs (HTTP/1.1 200) 8 headers in 358 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:22 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/create/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 40/40] 172.24.0.1 () {54 vars in 1019 bytes} [Wed Apr 17 00:32:22 2024] GET /static/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:00:32:22 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/create/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 41/41] 172.24.0.1 () {54 vars in 1019 bytes} [Wed Apr 17 00:32:22 2024] GET /static/css/base.css => generated 179 bytes in 5 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:01 +0000] "GET /course/create/ HTTP/1.1" 200 1911 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 42/42] 172.24.0.1 () {58 vars in 1167 bytes} [Wed Apr 17 01:33:01 2024] GET /course/create/ => generated 1911 bytes in 31 msecs (HTTP/1.1 200) 8 headers in 358 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 43/43] 172.24.0.1 () {54 vars in 1019 bytes} [Wed Apr 17 01:33:01 2024] GET /static/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:01 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/create/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:06 +0000] "GET /course/ HTTP/1.1" 404 179 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 44/44] 172.24.0.1 () {56 vars in 1122 bytes} [Wed Apr 17 01:33:06 2024] GET /course/ => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-web-1    | [pid: 18|app: 0|req: 45/45] 172.24.0.1 () {56 vars in 1120 bytes} [Wed Apr 17 01:33:10 2024] GET /course => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:10 +0000] "GET /course HTTP/1.1" 404 179 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:24 +0000] "GET /course/mine/ HTTP/1.1" 200 1120 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 46/46] 172.24.0.1 () {56 vars in 1132 bytes} [Wed Apr 17 01:33:24 2024] GET /course/mine/ => generated 1120 bytes in 23 msecs (HTTP/1.1 200) 8 headers in 358 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:24 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/mine/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 47/47] 172.24.0.1 () {54 vars in 1017 bytes} [Wed Apr 17 01:33:24 2024] GET /static/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:31 +0000] "GET /course/create/ HTTP/1.1" 200 1911 "http://localhost/course/mine/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 48/48] 172.24.0.1 () {58 vars in 1188 bytes} [Wed Apr 17 01:33:31 2024] GET /course/create/ => generated 1911 bytes in 32 msecs (HTTP/1.1 200) 8 headers in 358 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:31 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/create/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 49/49] 172.24.0.1 () {54 vars in 1019 bytes} [Wed Apr 17 01:33:31 2024] GET /static/css/base.css => generated 179 bytes in 1 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)
elearning-nginx-1  | 172.24.0.1 - - [17/Apr/2024:01:33:31 +0000] "GET /static/css/base.css HTTP/1.1" 404 179 "http://localhost/course/create/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
elearning-web-1    | [pid: 18|app: 0|req: 50/50] 172.24.0.1 () {54 vars in 1019 bytes} [Wed Apr 17 01:33:31 2024] GET /static/css/base.css => generated 179 bytes in 2 msecs (HTTP/1.1 404) 6 headers in 214 bytes (1 switches on core 0)

```