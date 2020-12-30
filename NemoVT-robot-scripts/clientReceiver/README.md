# Salvataggio e condivisione dati

## Come funziona
Si basa su MQTT, un protocollo TCP per lo scambio di dati che si distingue per non essere vincolato dalla rete.

Per avere accesso alla comunicazione bisogna possedere un certificato crittografato in RSA, che garantisce la privacy e la sicurezza di dati, gestita dal protocllo TLS. I dati dell'utente sono quindi perfettamente al sicuro e protetti.

Il salvataggio di dati avviene dopo un breve periodo di tempo di raccolta dati.

Come avviene la comunicazione tra gli host:
1. Dopo aver ricevuto i dati, Halocode li invia tramite MQTT ad un topic, denominato "Topic Sensori".
2. Il client messo in ascolto allo stesso topic acquisisce i dati, successivamente inseriti in file csv.
3. Il dataset viene caricato su Google Drive automaticamente dal client.

## Liberie utilizzate
+ google-api-python-client
+ google-auth-oauthlib
+ tqdm
+ oauth2client
