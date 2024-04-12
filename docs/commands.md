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