// SCA - Scala/sbt packages with known vulnerabilities

name := "gh-app2"
version := "1.0.0"
scalaVersion := "2.12.10"

libraryDependencies ++= Seq(
  // Akka HTTP - CVE-2021-23339 - request smuggling
  "com.typesafe.akka" %% "akka-http" % "10.1.12",

  // Play Framework - CVE-2019-17598 - path traversal
  "com.typesafe.play" %% "play" % "2.7.0",

  // Apache Spark - CVE-2022-33891 - shell injection
  "org.apache.spark" %% "spark-core" % "3.2.1",

  // Scala XML - CVE-2022-36944 - XXE
  "org.scala-lang.modules" %% "scala-xml" % "1.3.0",

  // Jackson Scala - CVE-2019-14379 - deserialization RCE
  "com.fasterxml.jackson.module" %% "jackson-module-scala" % "2.9.9",

  // Slick - SQLi via raw queries
  "com.typesafe.slick" %% "slick" % "3.3.0",

  // Log4j (Log4Shell) - CVE-2021-44228
  "org.apache.logging.log4j" % "log4j-core" % "2.14.1",

  // Netty - CVE-2021-21290 - temp file info disclosure
  "io.netty" % "netty-all" % "4.1.59.Final",

  // Bouncy Castle - CVE-2020-28052 - auth bypass
  "org.bouncycastle" % "bcprov-jdk15on" % "1.66",

  // Scalatra - CVE-2021-41148 - path traversal
  "org.scalatra" %% "scalatra" % "2.7.0",

  // Spray JSON - DoS via deeply nested JSON
  "io.spray" %% "spray-json" % "1.3.5",

  // Guava - CVE-2023-2976 - temp file info disclosure
  "com.google.guava" % "guava" % "29.0-jre",

  // Commons-Collections - CVE-2015-6420 - deserialization RCE
  "commons-collections" % "commons-collections" % "3.2.1",

  // H2 - CVE-2022-23221 - RCE via JNDI
  "com.h2database" % "h2" % "2.0.204"
)
