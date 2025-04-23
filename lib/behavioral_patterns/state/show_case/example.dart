// === Интерфейс состояния ===
abstract class TicketMachineState {
  void insertMoney(TicketMachine context, int amount);
  void selectTicket(TicketMachine context);
  void dispense(TicketMachine context);
}

// === Состояние: Idle ===
class IdleState implements TicketMachineState {
  @override
  void insertMoney(TicketMachine context, int amount) {
    context.balance += amount;
    print("Inserted \$${amount}, balance is now \$${context.balance}");
    context.setState(HasMoneyState());
  }

  @override
  void selectTicket(TicketMachine context) {
    print("Insert money first");
  }

  @override
  void dispense(TicketMachine context) {
    print("Nothing to dispense");
  }
}

// === Состояние: HasMoney ===
class HasMoneyState implements TicketMachineState {
  @override
  void insertMoney(TicketMachine context, int amount) {
    context.balance += amount;
    print("Added \$${amount}, total: \$${context.balance}");
  }

  @override
  void selectTicket(TicketMachine context) {
    if (context.tickets <= 0) {
      print("No tickets left");
      context.setState(OutOfTicketsState());
    } else if (context.balance >= context.ticketPrice) {
      context.setState(DispensingState());
      context.dispense();
    } else {
      print("Not enough money. Ticket costs \$${context.ticketPrice}");
    }
  }

  @override
  void dispense(TicketMachine context) {
    print("Please select a ticket first");
  }
}

// === Состояние: Dispensing ===
class DispensingState implements TicketMachineState {
  @override
  void insertMoney(TicketMachine context, int amount) {
    print("Wait, dispensing...");
  }

  @override
  void selectTicket(TicketMachine context) {
    print("Already dispensing");
  }

  @override
  void dispense(TicketMachine context) {
    context.tickets--;
    context.balance -= context.ticketPrice;
    print("Dispensed 1 ticket 🎫. Tickets left: ${context.tickets}");

    if (context.tickets == 0) {
      context.setState(OutOfTicketsState());
    } else if (context.balance >= context.ticketPrice) {
      print("Balance enough for another ticket");
      context.setState(HasMoneyState());
    } else {
      context.setState(IdleState());
    }
  }
}

// === Состояние: OutOfTickets ===
class OutOfTicketsState implements TicketMachineState {
  @override
  void insertMoney(TicketMachine context, int amount) {
    print("Sorry, no tickets available");
  }

  @override
  void selectTicket(TicketMachine context) {
    print("Sorry, sold out");
  }

  @override
  void dispense(TicketMachine context) {
    print("Can't dispense, sold out");
  }
}

// === Контекст: сам автомат ===
class TicketMachine {
  late TicketMachineState _state;
  int tickets;
  int balance = 0;
  final int ticketPrice;

  TicketMachine({required this.tickets, this.ticketPrice = 10}) {
    _state = tickets > 0 ? IdleState() : OutOfTicketsState();
  }

  void setState(TicketMachineState state) {
    _state = state;
  }

  void insertMoney(int amount) => _state.insertMoney(this, amount);
  void selectTicket() => _state.selectTicket(this);
  void dispense() => _state.dispense(this);
}

// === Точка входа ===
void main() {
  final machine = TicketMachine(tickets: 2);

  machine.selectTicket(); // → Insert money first
  machine.insertMoney(5); // → Not enough
  machine.selectTicket(); // → Not enough
  machine.insertMoney(10); // → Balance: 15
  machine.selectTicket(); // → Dispense

  machine.selectTicket(); // → Not enough
  machine.insertMoney(10); // → Enough
  machine.selectTicket(); // → Dispense second ticket

  machine.insertMoney(10); // → Sold out
  machine.selectTicket(); // → Sold out
}
