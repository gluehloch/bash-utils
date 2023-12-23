import groovy.xml.*;

def red() {
    print "\033[31;1m"
}

def yellow() {
    print "\033[33m"
}

def green() {
    print "\033[32m"
}

def reset() {
    print "\033[0m"
}

def ok() {
    green()
    println "    Ok"
    reset()
}

green()
println """
///
/// AWTools
///     Start POM Checker ...
///
"""
reset()

/*
def fg = 30
def bg = 46
def style = "${(char)27}[$fg;$bg"+"m"
*/

def pom
try {
    pom = new XmlSlurper().parse(new File("pom.xml"))
} catch (FileNotFoundException ex) {
    println "This is not a Maven project. There is no pom.xml"
    return
}

def derivedGroupId = pom.groupId?.text() ?: pom.parent.groupId

def enableWarning = false

if (pom.parent.version.toString().contains('SNAPSHOT')) {
    yellow()
} else {
    green()
}
println ""
println "Parent POM:"
println "    ${pom.parent.groupId}:${pom.parent.artifactId}:${pom.parent.version}"
reset()
if (pom.version.toString().contains('SNAPSHOT')) {
    yellow()
} else {
    green()
}
println ""
println "Project POM:"
println "    ${derivedGroupId}:${pom.artifactId}:${pom.version}"
reset()

println ""
println "Dependencies:"
pom.dependencies.dependency.each { dependency ->
    if (dependency.version.toString().contains('SNAPSHOT')) {
        yellow()
        enableWarning = true
    }
    println "    ${dependency.groupId}:${dependency.artifactId}:${dependency.version}"
    reset()
}

println ""

// changes.xml properly modified with release date?
println "changes.xml:"
def changesXmlAsFile = new File("./src/changes/changes.xml")
def changesXml = new XmlSlurper().parse(changesXmlAsFile)
def lastReleaseElement = changesXml.body.release[0]
def today = new Date().format('yyyy-MM-dd')
if (lastReleaseElement.@date.toString().contains('??-??')) {
    enableWarning = true
    yellow()
    println "    Release date is undefined: ${lastReleaseElement.@date.toString()}"
    reset()
} else if (!lastReleaseElement.@date.toString().contains(today)) {
    enableWarning = true
    yellow();
    println "    Release date is not today: ${lastReleaseElement.@date.toString()}"
    reset()
} else {
    ok()
}

// TODO Are there uncommited changes?
def sout = new StringBuilder()
def serr = new StringBuilder()
def proc = 'git status'.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)
println ""
println "Git repository:"
if (sout.toString().contains('git add')) {
    enableWarning = true
    yellow()
    println "    Uncommited changes! Check with git status."
} else {
    ok()
}
// println "out> $sout err> $serr"

println ""
if (enableWarning) {
    red()
    println "///"
    println "///  Check all WARNINGS."
    println "///"
    reset()
} else {
    println "Release me!"
    ok()
}

// Check: changes.xml No ??-?? dates declated?
// Check: Expected version defined? Take version as parameter.
