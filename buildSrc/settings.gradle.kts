import de.fayard.refreshVersions.*

buildscript {
  repositories { gradlePluginPortal() }
  dependencies {
    classpath("de.fayard.refreshVersions:refreshVersions:0.9.7")
  }
}

bootstrapRefreshVersionsForBuildSrc()
