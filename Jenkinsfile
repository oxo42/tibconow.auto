// vim: ft=groovy

node {
    stage 'Checkout'
    git url: '/git/tibconow.auto'


    stage 'Build EAR'
    def application = 'tibconow.auto.application'
    def remote = 'tibco@bw.vm'
    def domain = 'domain1'
    def appspace = 'auto'
    def profile = 'default'

	def version = getVersion(application)
    def ear = "${application}_${version}.ear"
    def appver = version - ~/\.\d+$/
    def mvnHome = tool 'M3'

	echo "Version ${version}"

    sh "${mvnHome}/bin/mvn -f ${application}.parent/pom.xml clean package"

    stage "Upload artifacts"
    sh "ssh $remote \"mkdir -p $application\""

    sh "scp ${application}/target/${application}_${version}.ear $remote:~/$application"
    sh "scp deploy_bw_app.sh $remote:$application"

    stage "Deploy"
    sh "ssh $remote \"sudo bash $application/deploy_bw_app.sh $domain $appspace $application $ear $appver $profile\""
}

def getVersion(String application) {
    def matcher = readFile("${application}/META-INF/MANIFEST.MF") =~ /Bundle-Version: (\d+\.\d+\.\d+)/
    matcher ? matcher[0][1] : null
}
