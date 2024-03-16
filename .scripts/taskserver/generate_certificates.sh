#!/bin/sh

help() { 
    if [ -z "${SCRIPT}" ];
    then
        SCRIPT=$(basename "$0")
    fi
    printf "\n"
    printf "Generate and configure ALL Certificates for my Task Server\n"
    printf "\n"
    printf "Usage:\n"
    printf "\t%s -i|--identity-file identity-file -s|--task-server task-server-ip\n" "${SCRIPT}"
    printf "\n"
    printf "Options:\n"
    printf "\t-i, --identity-file:\n"
    printf "\tPath of the SSH Identity File to connect to the Tassk Server.\n"
    printf "\n"
    printf "\t-s, --task-server:\n"
    printf "\tThe IP address of the Task Server.\n"
    printf "\n"
    printf "Examples:\n"
    printf "\t%s -i ~/.ssh/my-super-key 1.2.3.4 \n" "${SCRIPT}"
    printf "\n"
    exit 1
}

for arg in "$@"; do
  shift
  case "$arg" in
    '--help')               set -- "$@" '-h'   ;;
    '--identity-filer')     set -- "$@" '-i'   ;;
    '--task-server')        set -- "$@" '-s'   ;;
    *)                      set -- "$@" "$arg" ;;
  esac
done

while getopts ":h:i:s:" option; do
    case "${option}" in
        h)
            help
            ;;    
        i)
            IDENTIFTY_FILE=${OPTARG}
            ;;
        s)
            TASK_SERVER_IP=${OPTARG}
            ;;
        *)
            help
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${IDENTIFTY_FILE}" ] || [ -z ${TASK_SERVER_IP} ]; then
    help
fi

TASK_WARRIOR_CONFIG_DIR="${HOME}/.task"

TASK_SERVER_CONFIG_DIR="/var/taskd"

TEMP_DIR="$(mktemp -d)"

cd $TEMP_DIR

# 1 - Generate Root CA
openssl req -x509 \
              -sha256 -days 356 \
               -nodes \
               -newkey rsa:4096 \
               -subj "/CN=www.ronkitay.com/C=IL/L=Tel Aviv" \
               -keyout root-CA.key.pem -out root-CA.cert.pem

# 2 - Generate Task Server Private Key
openssl genrsa -out task-server.key.pem 2048

# 3 - Generate Task Server CSR Config File
CSR_CONFIG_FILE="server.csr.conf"

echo "[ req ]" >> ${CSR_CONFIG_FILE}
echo "default_bits = 2048" >> ${CSR_CONFIG_FILE}
echo "prompt = no" >> ${CSR_CONFIG_FILE}
echo "default_md = sha256" >> ${CSR_CONFIG_FILE}
echo "req_extensions = req_ext" >> ${CSR_CONFIG_FILE}
echo "distinguished_name = dn" >> ${CSR_CONFIG_FILE}
echo "" >> ${CSR_CONFIG_FILE}
echo "[ dn ]" >> ${CSR_CONFIG_FILE}
echo "C = IL" >> ${CSR_CONFIG_FILE}
echo "L = Tel Aviv" >> ${CSR_CONFIG_FILE}
echo "O = Ron Kitay" >> ${CSR_CONFIG_FILE}
echo "OU = Ron Kitay Dev" >> ${CSR_CONFIG_FILE}
echo "CN = ${TASK_SERVER_IP}" >> ${CSR_CONFIG_FILE}
echo "" >> ${CSR_CONFIG_FILE}
echo "[ req_ext ]" >> ${CSR_CONFIG_FILE}
echo "subjectAltName = @alt_names" >> ${CSR_CONFIG_FILE}
echo "" >> ${CSR_CONFIG_FILE}
echo "[ alt_names ]" >> ${CSR_CONFIG_FILE}
echo "DNS.1 = taskserver.ronkitay.com" >> ${CSR_CONFIG_FILE}
echo "IP.1 = ${TASK_SERVER_IP}" >> ${CSR_CONFIG_FILE}


# 4 - Generate Task Server CSR
openssl req -new -key task-server.key.pem -out task-server.csr -config ${CSR_CONFIG_FILE}

# 5 - Generate Task Server Certificate Config File

CERT_CONFIG_FILE="server.cert.conf"

echo "authorityKeyIdentifier=keyid,issuer" >> ${CERT_CONFIG_FILE}
echo "basicConstraints=CA:FALSE" >> ${CERT_CONFIG_FILE}
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" >> ${CERT_CONFIG_FILE}
echo "subjectAltName = @alt_names" >> ${CERT_CONFIG_FILE}
echo "" >> ${CERT_CONFIG_FILE}
echo "[ alt_names ]" >> ${CERT_CONFIG_FILE}
echo "DNS.1 = taskserver.ronkitay.com" >> ${CERT_CONFIG_FILE}

# 6 - Generate Task Server Certificate

openssl x509 -req \
    -days 365 -sha256 \
    -in task-server.csr \
    -CA root-CA.cert.pem -CAkey root-CA.key.pem \
    -CAcreateserial \
    -out task-server.cert.pem \
    -extfile ${CERT_CONFIG_FILE}

# 7 - Generate Client Private Key

openssl genrsa -out client.key.pem 4096

# 8 - Generate Client CSR

openssl req -new \
    -key client.key.pem \
    -subj "/CN=client/C=IL/L=Tel Aviv" \
    -out client.csr

# 9 - Generate Client Cert Config File

CLIENT_CERT_CONFIG_FILE="client.cert.ext.conf"

echo "basicConstraints = CA:FALSE" >> ${CLIENT_CERT_CONFIG_FILE}
echo "nsCertType = client" >> ${CLIENT_CERT_CONFIG_FILE}
echo "nsComment = \"OpenSSL Generated Client Certificate\"" >> ${CLIENT_CERT_CONFIG_FILE}
echo "subjectKeyIdentifier = hash" >> ${CLIENT_CERT_CONFIG_FILE}
echo "authorityKeyIdentifier = keyid,issuer" >> ${CLIENT_CERT_CONFIG_FILE}
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" >> ${CLIENT_CERT_CONFIG_FILE}
echo "extendedKeyUsage = clientAuth" >> ${CLIENT_CERT_CONFIG_FILE}

# 10 - Generate Client Certificate

openssl x509 -req \
    -days 365 -sha256 \
    -in client.csr \
    -CA root-CA.cert.pem -CAkey root-CA.key.pem \
    -out client.cert.pem \
    -CAcreateserial \
    -extfile ${CLIENT_CERT_CONFIG_FILE}

# 11 - Copy the generated certificates to the Task Server

scp -i ${IDENTIFTY_FILE} \
    root-CA.cert.pem \
    task-server.cert.pem \
    task-server.key.pem \
    client.cert.pem \
    client.key.pem \
    opc@${TASK_SERVER_IP}:${TASK_SERVER_CONFIG_DIR}

# 12 - Copy the generated certificates to the Task Warrior Config Directory

cp root-CA.cert.pem ${TASK_WARRIOR_CONFIG_DIR}/ca.cert.pem
cp client.cert.pem ${TASK_WARRIOR_CONFIG_DIR}/client.cert.pem
cp client.key.pem ${TASK_WARRIOR_CONFIG_DIR}/client.key.pem

# 13 - Configure Task Warrior to use the generated certificates

task config taskd.certificate -- ${TASK_WARRIOR_CONFIG_DIR}/client.cert.pem
task config taskd.key -- ${TASK_WARRIOR_CONFIG_DIR}/client.key.pem
task config taskd.ca -- ${TASK_WARRIOR_CONFIG_DIR}/ca.cert.pem

# 14 - Configure Task Server to use the generated certificates

ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "taskd config --data ${TASK_SERVER_CONFIG_DIR} --force client.cert ${TASK_SERVER_CONFIG_DIR}/client.cert.pem"
ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "taskd config --data ${TASK_SERVER_CONFIG_DIR} --force client.key ${TASK_SERVER_CONFIG_DIR}/client.key.pem"
ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "taskd config --data ${TASK_SERVER_CONFIG_DIR} --force server.cert ${TASK_SERVER_CONFIG_DIR}/task-server.cert.pem"
ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "taskd config --data ${TASK_SERVER_CONFIG_DIR} --force server.key ${TASK_SERVER_CONFIG_DIR}/task-server.key.pem"
ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "taskd config --data ${TASK_SERVER_CONFIG_DIR} --force ca.cert ${TASK_SERVER_CONFIG_DIR}/root-CA.cert.pem"

# 15 - Restart Task Server

ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "TASKDDATA=${TASK_SERVER_CONFIG_DIR} taskdctl stop"
ssh -i ${IDENTIFTY_FILE} opc@${TASK_SERVER_IP} "TASKDDATA=${TASK_SERVER_CONFIG_DIR} taskdctl start"

# 16 - Clean up

rm -rf "${TEMP_DIR}"
