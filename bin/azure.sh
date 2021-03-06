#!/bin/bash
#
# usage:
#   bin/azure.sh
#
# Generate manifest for Azure BOSH/NTP/nginx/DNS server
#
# --var-errs: don't use; it flags the variables I'll interpolate the _next_ stage
#
DEPLOYMENTS_DIR="$( cd "${BASH_SOURCE[0]%/*}" && pwd )/.."

cat > $DEPLOYMENTS_DIR/bosh-azure.yml <<EOF
# DON'T EDIT; THIS FILE IS AUTO-GENERATED
#
# bosh create-env bosh-azure.yml -l <(lpass show --note deployments.yml) -l <(curl -L https://raw.githubusercontent.com/cunnie/sslip.io/master/conf/sslip.io%2Bnono.io.yml) --vars-store=bosh-azure-creds.yml
# bosh -e bosh-azure.nono.io alias-env azure
#
EOF

bosh interpolate $DEPLOYMENTS_DIR/../bosh-deployment/bosh.yml \
  \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/azure/cpi.yml \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/azure/use-managed-disks.yml \
  \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/external-ip-with-registry-not-recommended.yml \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/jumpbox-user.yml \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/local-dns.yml \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/uaa.yml \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/external-ip-not-recommended-uaa.yml \
  -o $DEPLOYMENTS_DIR/../bosh-deployment/credhub.yml \
  \
  -o etc/azure.yml \
  -o etc/common.yml \
  -o etc/TLS.yml \
  -o etc/nginx.yml \
  -o etc/ntp.yml \
  -o etc/pdns.yml \
  \
  --vars-store=bosh-azure-creds.yml \
  --var-file commercial_ca_crt=etc/COMODORSACertificationAuthority.crt \
  --var-file nono_io_crt=etc/nono.io.crt \
  -v dns_recursor_ip="168.63.129.16" \
  -v internal_gw="10.0.0.1" \
  -v internal_cidr="10.0.0.0/24" \
  -v internal_ip="10.0.0.6" \
  -v external_ip="52.187.42.158" \
  -v director_name="azure" \
  -v vnet_name=boshnet \
  -v subnet_name=bosh \
  -v subscription_id=a1ac8d5a-7a97-4ed5-bfd1-d7822e19cae9 \
  -v tenant_id=682bd378-95db-41bd-8b1e-70fb407c4b10 \
  -v client_id=bf7f78c1-6924-4a02-965c-b66f481a9b5f \
  -v resource_group_name=bosh-res-group \
  -v default_security_group=nsg-bosh \
  -v external_fqdn="bosh-azure.nono.io" \
  \
  -v admin_password='((admin_password))' \
  -v blobstore_agent_password='((blobstore_agent_password))' \
  -v blobstore_director_password='((blobstore_director_password))' \
  -v credhub_admin_client_secret='((credhub_admin_client_secret))' \
  -v credhub_cli_password='((credhub_cli_password))' \
  -v credhub_encryption_password='((credhub_encryption_password))' \
  -v hm_password='((hm_password))' \
  -v mbus_bootstrap_password='((mbus_bootstrap_password))' \
  -v nats_password='((nats_password))' \
  -v postgres_password='((postgres_password))' \
  -v registry_password='((registry_password))' \
  -v uaa_admin_client_secret='((uaa_admin_client_secret))' \
  -v uaa_clients_director_to_credhub='((uaa_clients_director_to_credhub))' \
  -v uaa_login_client_secret='((uaa_login_client_secret))' \
  \
  >> $DEPLOYMENTS_DIR/bosh-azure.yml
