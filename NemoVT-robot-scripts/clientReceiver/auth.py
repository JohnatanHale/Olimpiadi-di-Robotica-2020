from __future__ import print_function
import httplib2
import os

from googleapiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

try:
    import argparse
    flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()
except ImportError:
    flags = None

#Definizione di una classe che permetta la gestione delle autorizzazioni per poter accedere alle API di google drive
class auth:
    def __init__(self,SCOPES,CLIENT_SECRET_FILE,APPLICATION_NAME):
        #Costruttore degli attributi utili
        self.SCOPES = SCOPES
        self.CLIENT_SECRET_FILE = CLIENT_SECRET_FILE
        self.APPLICATION_NAME = APPLICATION_NAME
    def getCredentials(self):
        #Creazione di un JSON che conterrà le chiavi di accesso (token)
        cwd_dir = os.getcwd()
        credential_dir = os.path.join(cwd_dir, '.credentials')
        if not os.path.exists(credential_dir):
            os.makedirs(credential_dir)
        credential_path = os.path.join(credential_dir, 'google-drive-credentials.json')

        store = Storage(credential_path)
        credentials = store.get()
        if not credentials or credentials.invalid:
            flow = client.flow_from_clientsecrets(self.CLIENT_SECRET_FILE, self.SCOPES)
            flow.user_agent = self.APPLICATION_NAME
            if flags:
                credentials = tools.run_flow(flow, store, flags)
            else: # Compatibilità con python 2.6
                credentials = tools.run(flow, store)
            print('Salvo le credenziali su ' + credential_path)
        return credentials