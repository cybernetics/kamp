plugins {
  kotlin("multiplatform")
  kotlin("plugin.serialization")
  id("com.github.johnrengelman.shadow")
  application
}

kotlin {
  jvm {
    withJava()
  }
  js {
    binaries.executable()
    browser()
  }
  
  sourceSets {
    named("jvmMain") {
      dependencies {
        implementation(project(rootProject.path))
        implementation("ch.qos.logback:logback-classic:1.2.3")
      }
    }
    named("jvmTest") {
      dependencies {
        implementation("io.kotest:kotest-runner-junit5:4.3.0")
      }
    }
  }
}

application {
  mainClassName = "kamp.AppKt"
}