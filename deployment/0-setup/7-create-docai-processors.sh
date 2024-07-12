#!/bin/bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


# reference - https://cloud.google.com/document-ai/docs/create-processor#enable-processor


LOCATION=us
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

set -x

#curl -X GET \
#    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#    "https://${LOCATION}-documentai.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}:fetchProcessorTypes" | jq '.processorTypes[].name'

#----------------------------------------------------------------
#"INVOICE_PROCESSOR"
#"CUSTOM_EXTRACTION_PROCESSOR"
#"FORM_PARSER_PROCESSOR"
#"OCR_PROCESSOR"
#"LENDING_DOCUMENT_SPLIT_PROCESSOR"
#"FORM_W2_PROCESSOR"
#"FORM_W9_PROCESSOR"
#"FORM_1040_PROCESSOR"
#"FORM_1099MISC_PROCESSOR"
#"FORM_1003_PROCESSOR"
#"PAYSTUB_PROCESSOR"
#"BANK_STATEMENT_PROCESSOR"
#"PROCUREMENT_DOCUMENT_SPLIT_PROCESSOR"
#"CUSTOM_CLASSIFICATION_PROCESSOR"
#"UTILITY_PROCESSOR"
#"FORM_1099DIV_PROCESSOR"
#"EXPENSE_PROCESSOR"
#"FORM_1099G_PROCESSOR"
#"FORM_1099INT_PROCESSOR"
#"FORM_1040SCH_C_PROCESSOR"
#"FORM_1040SCH_E_PROCESSOR"
#"CUSTOM_SPLITTING_PROCESSOR"
#"US_DRIVER_LICENSE_PROCESSOR"
#"US_PASSPORT_PROCESSOR"
#"FR_DRIVER_LICENSE_PROCESSOR"
#"FR_NATIONAL_ID_PROCESSOR"
#"FORM_1099R_PROCESSOR"
#"FORM_SSA1099_PROCESSOR"
#"FORM_1065_PROCESSOR"
#"FORM_1120_PROCESSOR"
#"FORM_1120S_PROCESSOR"
#"PURCHASE_ORDER_PROCESSOR"
#"FORM_SSA89_PROCESSOR"
#"FORM_VBA26_0551_PROCESSOR"
#"FORM_HUD92900B_PROCESSOR"
#"FORM_1040SCH_D_PROCESSOR"
#"RETIREMENT_INVESTMENT_STATEMENT_PROCESSOR"
#"MORTGAGE_STATEMENT_PROCESSOR"
#"HOA_STATEMENT_PROCESSOR"
#"FR_PASSPORT_PROCESSOR"
#"ID_PROOFING_PROCESSOR"
#"SUMMARY_PROCESSOR"
#----------------------------------------------------------------


curl -s -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d '{"type": "FORM_PARSER_PROCESSOR", "displayName": "DocAI_Form_Processor_EndPoint" }' \
    "https://${LOCATION}-documentai.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/processors" | jq '.processEndpoint'


curl -s -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d '{"type": "INVOICE_PROCESSOR", "displayName": "DocAI_Invoice_Processor_EndPoint"}' \
    "https://${LOCATION}-documentai.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/processors" | jq '.processEndpoint'

curl -s -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d '{"type": "OCR_PROCESSOR", "displayName": "DocAI_OCR_Processor_EndPoint"}' \
    "https://${LOCATION}-documentai.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/processors" | jq '.processEndpoint'


curl -s -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d '{"type": "PURCHASE_ORDER_PROCESSOR", "displayName": "DocAI_PO_Processor_EndPoint"}' \
    "https://${LOCATION}-documentai.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/processors" | jq '.processEndpoint'


curl -s -X GET \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://$LOCATION-documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/$LOCATION/processors" | jq '.processors[0].type, .processors[0].processEndpoint, .processors[1].type, .processors[1].processEndpoint, .processors[2].type, .processors[2].processEndpoint, .processors[3].type, .processors[3].processEndpoint'

touch $COMPLETED