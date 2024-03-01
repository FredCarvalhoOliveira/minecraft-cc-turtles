from cc import peripheral

class MessagingController:
    def __init__(self, id) -> None:
        self.id = id
        self.modem = peripheral.wrap("right")
        print(self.modem)


    def transmit(self):
        pass
