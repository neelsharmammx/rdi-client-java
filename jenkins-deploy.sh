#!/bin/bash -e

cd target/checkout
mvn clean package javadoc:aggregate

S3_BUCKET=s3://metamx-releases
ARTIFACT=$(xpath -q -e "/project/artifactId/text()" pom.xml 2>/dev/null)
TAG=$(xpath -q -e "/project/version/text()" pom.xml  2>/dev/null)
DIST_TAR=${ARTIFACT}-distribution-${TAG}-dist.tar.gz

S3_PATH=${S3_BUCKET}/${ARTIFACT}/${TAG}/

s3cmd -r put target/site ${S3_PATH}
s3cmd put distribution/target/${DIST_TAR} ${S3_PATH}
