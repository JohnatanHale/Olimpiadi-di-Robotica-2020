from __future__ import print_function
import httplib2
import os, io
import tqdm


from googleapiclient import discovery, errors
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage
from googleapiclient.http import MediaFileUpload, MediaIoBaseDownload

try:
    import argparse
    flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()
except ImportError:
    flags = None
import auth

#Dichiarazioni delle variabili utili per usufruire delle API di google drive
SCOPES = 'https://www.googleapis.com/auth/drive'
CLIENT_SECRET_FILE = 'client_secret.json'
APPLICATION_NAME = 'Drive API Python Quickstart'
authInst = auth.auth(SCOPES,CLIENT_SECRET_FILE,APPLICATION_NAME)
credentials = authInst.getCredentials()

#Richiesta di autorizzazione
http = credentials.authorize(httplib2.Http())
drive_service = discovery.build('drive', 'v3', http=http)

#Funzione che lista tutti i file e cartelle presenti nel drive
def listFiles():
    print('Ricerca di tutti i file in corso...')
    results = drive_service.files().list(
        fields="nextPageToken, files(id, name)").execute()
    items = results.get('files', [])
    if not items:
        print('Nessun file trovato.')
    else:
        print('Lista dei files:')
        for item in items:
            print('{0} ({1})'.format(item['name'], item['id']))

#Caricamento di un file sul drive
def uploadFile(filename,filepath,mimetype, pathID):
    print(f'Caricamento sul drive del file {filename} in corso...')
    if pathID != '!null':
        file_metadata = {
                        'name': filename, 
                        'parents': [pathID]
        }
    else:
        file_metadata = {
                        'name': filename
        }
    media = MediaFileUpload(filepath,
                            mimetype=mimetype)
    file = drive_service.files().create(body=file_metadata,
                                        media_body=media,
                                        fields='id').execute()
    print('File caricato con successo con ID: %s' % file.get('id'))

#Download di un file dal drive
def downloadFile(file_id,filepath):
    request = drive_service.files().get_media(fileId=file_id)
    fh = io.BytesIO()
    downloader = MediaIoBaseDownload(fh, request)
    done = False
    while not done:
        print("Download in corso...")
        status, done = downloader.next_chunk()
        print("Download terminato.")
    with io.open(filepath,'wb') as f:
        fh.seek(0)
        f.write(fh.read())

#Creazione di una cartella nel drive
def createFolder(name):
    print(f'Creazione della cartella {name} in corso...')
    file_metadata = {
    'name': name,
    'mimeType': 'application/vnd.google-apps.folder'
    }
    file = drive_service.files().create(body=file_metadata,
                                        fields='id').execute()
    print ('Cartella creata con ID: %s' % file.get('id'))

#Ricerca di un file data una stringa
def searchFile(query):
    print(f"Cerco {query}...")
    query = f"name contains '{query}'"
    results = drive_service.files().list(
    fields="nextPageToken, files(id, name, kind, mimeType)",q=query).execute()
    items = results.get('files', [])
    if not items:
        print('Nessun file trovato.')
    else:
        print('Lista dei files:')
        for item in items:
            print(item)
            print('{0} ({1})'.format(item['name'], item['id']))

#Aggiornamento di un file presente all'interno del drive
def updateFile(service, file_id, new_title, new_mime_type, new_filename):
    print('Aggiornamento del file...')
    try:
        # First retrieve the file from the API.
        file = service.files().get(fileId=file_id).execute()
        # File's new metadata.
        del file['id']
        file['name'] = new_title
        file['mimeType'] = new_mime_type
        file['trashed'] = False
        # File's new content.
        media_body = MediaFileUpload(
            new_filename, mimetype=new_mime_type, resumable=True)
        # Send the request to the API.
        updated_file = service.files().update(
            fileId=file_id,
            body=file,
            media_body=media_body).execute()
        print('File aggiornato')
        return updated_file
    except errors.HttpError as error:
        print('An error occurred: %s' % error)
        return None


#Inserire il nome che si vuole dare al file, la path e il mimetype
#Se l'ultimo parametro ÃƒÂ¨ '!null' allora non carica nella home
#Altrimenti per inserirlo dentro una cartella digitare l'id della cartella
#uploadFile('quickstart.py','quickstart.py','text/x-python','!null')

#Inserisci l'ID del file e la path dove vuoi installarlo. Inserire l'estensione uguale al file che si vuole scaricare
#downloadFile('File ID','nomefile.estensione')

#Inserisci il nome della cartella che vuoi creare
#createFolder('Nome della cartella')

#Inserisci una stringa al posto delle X
#searchFile('Stringa da cercare')

#Stampa di tutti i file presenti nel drive
#listFiles()