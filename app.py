from flask import Flask
from flask_ask import Ask, statement, question
from google.cloud import firestore
import logging

app = Flask(__name__)
ask = Ask(app, '/alexa')
db = firestore.Client()

@ask.on_session_started
def new_session():
    logging.info('new session started')

@ask.launch
def start_skill():
    welcome_message = 'Hello, would you like to know your expenses?'
    return question(welcome_message)

@ask.intent('YesIntent')
def share_categories():
    user_id = 'alovelace'
    # zip through categories and expenses
    users_ref = db.collection(u'users')
    docs = users_ref.get()

    response = ''
    for doc in docs:
        if doc.id == user_id:
            features = doc.to_dict()
            
            for row, key in enumerate(features):
                category = key
                expenses = features[key]
                dollars_in_category = '{0} dollars in {1}'.format(expenses, category)

                if len(features) == 1: # Only one expense, end the sentence.
                    reponse += ' {0}.'.format(dollars_in_category)
                else:
                    if row < len(features) - 1: # More expenses, use commas.
                        response += ' {0},'.format(dollars_in_category)
                    else: # Last expense, end the sentence.
                        response += ' and {0}.'.format(dollars_in_category)

    if response:
        return statement('You have spent{0}'.format(response))
    else:
        return statement('You have no recorded expenses.')

@ask.intent('NoIntent')
def goodbye():
    goodbye_message = 'Goodbye'
    return statement(goodbye_message)

if __name__=='__main__':
    app.run(debug=True)
