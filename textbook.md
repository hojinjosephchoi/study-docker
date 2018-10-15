# 도커
## 도커 기초
- 프로젝트 루트에서 Dockerfile 생성 및 작성 후 아래 명령어로 도커 이미지 빌드
```
$ docker build -t node-sample .
```

- 이미지 빌드 후 도커 실행
```
$ docker run -it --rm -p 3000:3000 nodesample
```

- db 컨테이너 실행
```
$ docker run -it --rm -p 5432:5432 --name db -e POSTGRES_DB=nodesample -e POSTGRES_USER=testuser -e POSTGRES_PASSWORD=testsecret postgres:9.6.1
```

- volume 옵션 지정
```
$ docker run -it --rm -p 5432:5432 --name db -e POSTGRES_DB=nodesample -e POSTGRES_USER=testuser -e POSTGRES_PASSWORD=testsecret --volume=$(pwd)/docker/data:/var/lib/postgresql/data postgres:9.6.1
$ docker run -it --rm -p 3000:3000 --name app --link db -e EXPRESS_DB_HOST=localhost --volume=$(pwd):/app/ nodesample
```

## Docker-Compose
- Dockerfile vs. Dockerfile-dev: 서버 구성을 문서화한 것(=클래스 선언이 들어 있는 파일)
- docker build vs. docker-compose build: 도커 이미지 만들기(=클래스 선언을 애플리케이션에 로드)
- docker run의 옵션들 vs. docker-compose.yml: 이미지에 붙이는 장식들(=인스턴스의 변수들)
- docker run vs. docker-compose up: 장식 붙은 이미지를 실제로 실행(=인스턴스 생성)

### 도커가 관리하는 가상의 디스크 만들기
- docker-compose.yml
```
volumes:
  express_sample_db_dev: {}
  express_sample_node_modules: {}

...

services:
  db:
    image: postgres:9.6.1
    volumes:
      - express_sample_db_dev:/var/lib/postgresql/data
```

- 가상디스크 확인 명령어
```
docker volume ls
```

### docker-compose 주요명령어
#### up
- 이미지 빌드+서비스 실행
```
$ docker-compose up -d
```

- 진행과정

  1. 서비스를 띄울 네트워크 설정
  2. 필요한 볼륨 생성
  3. 필요한 이미지 pull
  4. 필요한 이미지 build
  5. 서비스 의존성에 따라 서비스 실행

- `-d`: 서비스 실행 후 콘솔 빠져나옴
- `--force-recreate`: 컨테이너 지우고 새로 만듦
- `--build`: 서비스 시작 전 이미지 새로 만듦

> 주로 docker-compose up -d --build 형태로 많이 사용한다...

#### ps
- 현재 환경에서 실행중인 서비스 보여줌
```
$ docker-compose ps
```


#### stop, start
- 서비스를 멈추거나 멈춰있는 서비스를 시작
````
$ docker-compose stop
$ docker-compose start
````

#### down
- 서비스를 지움. `--volume` 옵션에 따라 볼륨도 삭제
```
$ docker-compose down --volume
```

#### exec
- 실행중인 컨테이너에서 명령어 실행
```
$ docker-compose exec django ./manage.py makemigrations
```


#### logs
- 서비스의 로그를 확인
```
$ docker-compose logs django
```
- `-f`: 지금까지 쌓인 로그를 다 보여준 후에도 셸로 나오지 않고 로그가 쌓일 때마다 계속 출력

----
## references
### 도커 컴포즈 설명자료 원본
- [http://raccoonyy.github.io/docker-usages-for-dev-environment-setup/](http://raccoonyy.github.io/docker-usages-for-dev-environment-setup/)

- [https://github.com/raccoonyy/express-sample-for-docker-compose](https://github.com/raccoonyy/express-sample-for-docker-compose)

### docker hub
- [https://hub.docker.com/_/postgres/](https://hub.docker.com/_/postgres/)

- 환경변수 옵션 등을 확인할 수 있다.

### docker compose file reference
- [https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)