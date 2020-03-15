sshpass -p vmsn2004 ssh -p 22 -o StrictHostKeyChecking=no root@regalonatural.es < cmd_borra_sql.cmd
sshpass -p vmsn2004 sftp -o StrictHostKeyChecking=no root@regalonatural.es < cmd_copia_sql.cmd

