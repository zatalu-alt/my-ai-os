from pathlib import Path
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

BASE = Path.home() / '.agent' / 'config' / 'google'
TOKEN = BASE / 'token.json'
SCOPES = [
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.compose',
]

creds = Credentials.from_authorized_user_file(str(TOKEN), SCOPES)
svc = build('gmail', 'v1', credentials=creds)
res = svc.users().profile().get(userId='me').execute()
print(res)
