#!/bin/bash

#k8s-deployment.sh
sed -i "s#replace#weizheng78/numeric-app:${GIT_COMMIT}#g" k8s_deployment_service.yaml
#sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
# kubectl -n default get deployment ${deploymentName} > /dev/null

# if [[ $? -ne 0 ]]; then
#     echo "deployment ${deploymentName} doesnt exist"
#     kubectl -n default apply -f k8s_deployment_service.yaml
# else
#     echo "deployment ${deploymentName} exist"
#     echo "image name - ${imageName}"
#     kubectl -n default set image deploy ${deploymentName} ${containerName}=${imageName} --record=true
# fi


kubectl -n default apply -f k8s_deployment_service.yaml