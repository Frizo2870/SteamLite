import psycopg2


class Connection:

    def __init__(self):
        self.connection = None

    def openConnection(self):
        try:
            self.connection = psycopg2.connect(user="postgres",
                                               password="123nose456",
                                               database="ingdatos",
                                               host="localhost",
                                               port="5432")
        except Exception as e:
            print(e)

    def closeConnection(self):
        self.connection.close()
