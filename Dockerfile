FROM openjdk:17 as build

LABEL maintainer="paail <evrok907@gmail.com>"

ARG JAR_FILE=build/libs/review-0.0.1-SNAPSHOT.jar

COPY ${JAR_FILE} app.jar

RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app.jar)

FROM openjdk:17

VOLUME /tmp

ARG DEPENDENCY=/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","com.gopang.review.ReviewApplication"]