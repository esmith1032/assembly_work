module load SOAPdenovo2
SOAPdenovo-127mer all -s /bigdata/bioinfo/esmit013/fungal_assembly/soap_raw_data/soap.config -K 63 -o /bigdata/
bioinfo/esmit013/fungal_assembly/soap_raw_data/soapgraph

##for processed data:
SOAPdenovo-127mer all -s /bigdata/bioinfo/esmit013/fungal_assembly/soap_processed_data/soap.config -K 63 -o /bigdata/
bioinfo/esmit013/fungal_assembly/soap_processed_data/soapgraph
