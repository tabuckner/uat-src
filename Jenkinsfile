node {
	try {
		// Environment Variables
		env.appname  = "GambitCard"
		env.scmCreds = "e0de9ac3-3636-48d7-b95e-35443ab32b53"
		env.scmType  = "git"
		env.ddbURL   = "ssh://jenkins@win-20e107kb4tn:7999/gc/gambitcard.git"
		env.srcURL   = "ssh://jenkins@win-20e107kb4tn:7999/gc/gambitcardsql.git"
		// Pad env.BUILD_NUMBER so fetching LATEST will work properly on Artifactory and Xebia XLD
		// Requires https://wiki.jenkins.io/display/JENKINS/Permissive+Script+Security+Plugin
		env.BUILD_NUMBER = "${env.BUILD_NUMBER}".padLeft(4,'0')
		
		//MOVED TO JENKINS NODE SETTINGS
		//env.DATICAL_CLIENT_SECRET="123abc"
		//env.DATICAL_SERVER="hostname"
		//env.curlHome = "C:\\apps\\Git\\mingw64\\bin"
		//env.datHome  = "C:\\apps\\DaticalDB\\repl"
		//env.mvnHome  = "C:\\apps\\apache-maven-3.3.9\\bin"
		//env.ucdHome  = "C:\\apps\\ibm-ucd-agent\\opt\\udclient"
		//env.ZipHome  = "C:\\apps\\7-Zip"
		
		// Print Environment Variables
		//echo sh(returnStdout: true, script: 'env')
						
		// String Definitions
		//def appname  = "${env.appname}"
		
		deleteDir()

		stage('Source Checkout') {
			if (env.scmType == 'git') {
				parallel (
					CheckoutDDB: {
						checkout([$class: "GitSCM", branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: "RelativeTargetDirectory", relativeTargetDir: "ddb"], [$class: "LocalBranch", localBranch: "master"], [$class: "UserIdentity", email: "jenkins@company.com", name: "jenkins"]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "${env.scmCreds}", url: "${env.ddbURL}"]]])
					},

					CheckoutAPP: {
						checkout([$class: "GitSCM", branches: [[name: "*/${env.pipeline}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: "RelativeTargetDirectory", relativeTargetDir: "src"], [$class: "LocalBranch", localBranch: "${env.pipeline}"], [$class: "UserIdentity", email: "jenkins@company.com", name: "jenkins"]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "${env.scmCreds}", url: "${env.srcURL}"]]])
					}
				)
			}
			
			if (env.scmType == 'svn') {
				parallel (
					CheckoutDDB: {					
						checkout changelog: false, poll: false, scm: [$class: "SubversionSCM", additionalCredentials: [], excludedCommitMessages: "", excludedRegions: "", excludedRevprop: "", excludedUsers: "", filterChangelog: false, ignoreDirPropChanges: false, includedRegions: "", locations: [[credentialsId: "7545c833-66a0-4386-8a16-9d8a51c98449", depthOption: "infinity", ignoreExternalsOption: true, local: "ddb", remote: "${env.ddbURL}"], [credentialsId: "7545c833-66a0-4386-8a16-9d8a51c98449", depthOption: "infinity", ignoreExternalsOption: true, local: "ddb", remote: "${env.ddbURL}"]], workspaceUpdater: [$class: "UpdateUpdater"]]
					},

					CheckoutAPP: {
						checkout changelog: false, poll: false, scm: [$class: "SubversionSCM", additionalCredentials: [], excludedCommitMessages: "", excludedRegions: "", excludedRevprop: "", excludedUsers: "", filterChangelog: false, ignoreDirPropChanges: false, includedRegions: "", locations: [[credentialsId: "7545c833-66a0-4386-8a16-9d8a51c98449", depthOption: "infinity", ignoreExternalsOption: true, local: "src", remote: "${env.srcURL}"], [credentialsId: "7545c833-66a0-4386-8a16-9d8a51c98449", depthOption: "infinity", ignoreExternalsOption: true, local: "src", remote: "${env.srcURL}"]], workspaceUpdater: [$class: "UpdateUpdater"]]
					}
				)
			}
		}

		stage('PackageDB') {
			// Set Upstream Branches for Git
			if (env.scmType == 'git') {
				bat 'cd src && git branch --set-upstream-to=origin/%pipeline% %pipeline%'
				bat 'cd ddb && git branch --set-upstream-to=origin/master master'
			}
			
			// Show Hammer Version Details
			//bat 'hammer.bat show version'

			// Set Version
			if (env.pipeline == 'pipeline1') {
				env.version = "2.0.${env.BUILD_NUMBER}"
			}
			
			if (env.pipeline == 'pipeline2') {
				env.version = "3.0.${env.BUILD_NUMBER}"
			}
			
			if (env.pipeline == 'hotfix') {
				//ASSUME YOU ARE HOTFIXING CURRENT VERSION
				env.version = "1.0.${env.BUILD_NUMBER}_HOTFIX"
			}						
			
			// Invoke Datical Database Code Packager
			withCredentials([usernamePassword(credentialsId: 'DATICAL5', usernameVariable: 'DATICAL_USERNAME', passwordVariable: 'DATICAL_PASSWORD')]) {
				//bat 'cd ddb && hammer.bat groovy deployPackager.groovy %pipeline% scm=true labels=%BUILD_TAG%'
				bat 'cd ddb && hammer.bat groovy deployPackager.groovy pipeline=%pipeline% --projectKey=%appname% scm=true labels=%version%'
			}		
			
			// Create Datical Artifact
			bat 'cd ddb && 7za.exe a -tzip -x!.git -x!.svn -x!Logs -x!Reports -x!Snapshots -x!Profiles -x!.classpath -x!.gitignore -x!.metadata -x!.project -x!.reporttemplates -x!daticaldb.log -x!deployPackager.properties -x!svn-ignore.properties ..\\%appname%DB.zip'
		}

		stage('BuildApp') {
			bat 'sed -i s/VERSION_NO/%version%/g .\\src\\app_code\\src\\main\\webapp\\index.jsp'
			bat 'cd src\\app_code && mvn package'
			bat 'move src\\app_code\\target\\%appname%-1.0-SNAPSHOT.war .\\%appname%.war'
		}

		stage('Package Artifact') {
			if (env.CDTool != 'UCD') {
				// Artifactory Configuration
				def server = Artifactory.server 'art-001'

				def buildInfo = Artifactory.newBuildInfo()
				// Set custom build name and number.
				buildInfo.setName "${env.appname}"
				buildInfo.setNumber "${env.version}"

				def uploadSpec = """ {
					"files": [
						{
							"pattern": "*zip",
							"target": "${env.appname}/${env.appname}DB-${env.version}.zip",
							"props": "pipeline=${env.pipeline}"
						},
						{
							"pattern": "*war",
							"target": "${env.appname}/${env.appname}-${env.version}.war",
							"props": "pipeline=${env.pipeline}"
						}
					]
				}"""
				
				// Upload to Artifactory.
				server.upload spec: uploadSpec, buildInfo: buildInfo
		
				// Publish build info.
				server.publishBuildInfo buildInfo
				
				if (env.CDTool == 'XLD') {
					// used to create and publish the artifacts in XLD
					xldCreatePackage artifactsPath: ".", manifestPath:"src/deployit-manifest.xml", darPath: '${appname}-${version}.dar'
					xldPublishPackage serverCredentials: 'Admin', darPath: '${appname}-${version}.dar'

					//xldCreatePackage artifactsPath: ".", manifestPath:"src/sql_code/deployit-manifest_ddb.xml", darPath: '${appname}_ddb-${version}.dar'
					//xldPublishPackage serverCredentials: 'Admin', darPath: '${appname}_ddb-${version}.dar'
				}
			}
			
			if (env.CDTool == 'UCD') {
				// Add UCD Component Version
				bat 'udclient.cmd -username admin -password password -weburl https://win-20e107kb4tn:8444 createVersion -component %appname%-DB -name %version%'
				bat 'udclient.cmd -username admin -password password -weburl https://win-20e107kb4tn:8444 createVersion -component %appname%-WAR -name %version%'
				
				// Add Files to new Component Version
				bat 'udclient.cmd -username admin -password password -weburl https://win-20e107kb4tn:8444 addVersionFiles -component %appname%-DB -version %version% -base %WORKSPACE% -include **/%appname%*.zip'
				bat 'udclient.cmd -username admin -password password -weburl https://win-20e107kb4tn:8444 addVersionFiles -component %appname%-WAR -version %version% -base %WORKSPACE% -include **/%appname%*.war'				
			}
		}

		if (env.pipeline != 'hotfix') {
			stage('Deploy To DEV') {
				env.deployenv = "DEV"
				
				parallel(
					DeployApp: {
						if (env.pipeline == 'pipeline1') {
							env.deployenv = "DEV"
						}
						
						if (env.pipeline == 'pipeline2') {
							env.deployenv = "DEV2"
						}
						
						build job: String.valueOf(appname) + '-DEP',
							parameters: [
								string(name: 'pipeline', value: String.valueOf("${env.pipeline}")),
								string(name: 'labels', value: String.valueOf("${env.pipeline}")),
								string(name: 'deployenv', value: String.valueOf("${env.deployenv}")),
								string(name: 'deployver', value: String.valueOf("${env.version}")),
								string(name: 'CDTool', value: String.valueOf("${env.CDTool}"))
							]					
					},
					
					DeployDB: {
						//xldDeploy serverCredentials: 'Admin', environmentId: 'Environments/${deployenv} ENV', packageId: 'Applications/${env.appname}_ddb/${version}'
						//Refresh Pipeline for DMC Status
						//bat 'cd ddb && hammer.bat status'
						withCredentials([usernamePassword(credentialsId: 'DATICAL5', usernameVariable: 'DATICAL_USERNAME', passwordVariable: 'DATICAL_PASSWORD')]) {
								bat 'cd ddb && hammer.bat status %appname%'
						}
					}
				)
			}
		   
			stage('Promotion Approval') {
				echo 'wait for approval'
			}
			
			input 'Continue to Deploy TEST'

			stage('Deploy To TEST') {
				env.deployenv = "TEST"
			
				parallel(
					DeployApp: {
				        if (env.pipeline == 'pipeline1') {
							env.deployenv = "TEST"
						}
						
						if (env.pipeline == 'pipeline2') {
							env.deployenv = "TEST2"
						}
						
	                    build job: String.valueOf(appname) + '-DEP',
							parameters: [
								string(name: 'pipeline', value: String.valueOf("${env.pipeline}")),
								string(name: 'labels', value: String.valueOf("${env.pipeline}")),
								string(name: 'deployenv', value: String.valueOf("${env.deployenv}")),
								string(name: 'deployver', value: '1.0.' + String.valueOf("${env.version}")),
								string(name: 'CDTool', value: String.valueOf("${env.CDTool}"))
							]					
					},

					
					DeployDB: {
						//xldDeploy serverCredentials: 'Admin', environmentId: 'Environments/${deployenv} ENV', packageId: 'Applications/${env.appname}_ddb/${version}'
						sleep 15
					}
				)
			}
		}
		
		stage('Promotion Approval') {
			echo 'wait for approval'
		}

		input 'Continue to Deploy PROD'
		
		stage('Deploy To PROD') {
			env.deployenv = "PROD"
			
			parallel(
				DeployApp: {
					build job: String.valueOf(appname) + '-DEP',
						parameters: [
							string(name: 'pipeline', value: String.valueOf("${env.pipeline}")),
							string(name: 'labels', value: String.valueOf("${env.pipeline}")),
							string(name: 'deployenv', value: String.valueOf("${env.deployenv}")),
							string(name: 'deployver', value: String.valueOf("${env.version}")),
							string(name: 'CDTool', value: String.valueOf("${env.CDTool}"))
						]
				},
				
				DeployDB: {
					if (env.pipeline == 'hotfix') {
						withCredentials([usernamePassword(credentialsId: 'DATICAL5', usernameVariable: 'DATICAL_USERNAME', passwordVariable: 'DATICAL_PASSWORD')]) {
							bat 'cd ddb\\%appname% && hammer.bat status %appname%'
						}
					}
				}
			)
		}
		
	} catch (e) {
		// If there was an exception thrown, the build failed
		currentBuild.result = "FAILED"
		throw e
	} finally {
		// Success or failure, always send notifications
		notifyBuild(currentBuild.result)
		archiveArtifacts allowEmptyArchive: true, artifacts: '**/ddb/**/Reports/**'
	}
}

def notifyBuild(String buildStatus = 'STARTED') {
	// build status of null means successful
	buildStatus =  buildStatus ?: 'SUCCESSFUL'
	
	def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
	//def summary = "${subject} (${env.BUILD_URL})"
	def summary = "${subject} (http://win-20e107kb4tn:8080/blue/organizations/jenkins/${env.JOB_NAME}/detail/${env.JOB_NAME}/${env.BUILD_NUMBER}/pipeline)"
	
	// Send notifications
	mail bcc: '', body: summary, cc: '', from: 'jenkins@company.local', replyTo: '', subject: subject, to: 'dev@company.local'
}