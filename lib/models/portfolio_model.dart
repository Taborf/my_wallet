import 'package:flutter/material.dart';

class PortfolioModel extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<SecurityPrice> _prices = [];
  
  // Fondo USD
  double _usdFundInvestment = 0;
  double _usdFundValue = 0;
  double _gainRealizedFund = 0;
  
  // EUR cash
  double _eurCash = 0;
  
  // USD cash
  double _usdCash = 0;
  
  double _currentUsdRate = 1.0;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<SecurityPrice> get prices => _prices;
  double get usdFundInvestment => _usdFundInvestment;
  double get usdFundValue => _usdFundValue;
  double get gainRealizedFund => _gainRealizedFund;
  double get eurCash => _eurCash;
  double get usdCash => _usdCash;
  double get currentUsdRate => _currentUsdRate;

  void initialize() {
    // Carica dati da memoria
    loadFromStorage();
    notifyListeners();
  }

  void loadFromStorage() {
    // TODO: Implementare caricamento da SharedPreferences
  }

  void addDeposit(double amount, String currency, DateTime date) {
    _transactions.add(
      Transaction(
        id: DateTime.now().toString(),
        type: TransactionType.deposit,
        date: date,
        currency: currency,
        amount: amount,
      ),
    );
    
    if (currency == 'EUR') {
      _eurCash += amount;
    } else if (currency == 'USD') {
      _usdCash += amount;
    }
    
    _recalculate();
    notifyListeners();
  }

  void addExchange(
    DateTime date,
    String fromCurrency,
    double fromAmount,
    String toCurrency,
    double toAmount,
  ) {
    double rate = fromAmount / toAmount;
    
    _transactions.add(
      Transaction(
        id: DateTime.now().toString(),
        type: TransactionType.exchange,
        date: date,
        currency: '$fromCurrency→$toCurrency',
        amount: fromAmount,
        exchangeRate: rate,
      ),
    );

    if (fromCurrency == 'EUR' && toCurrency == 'USD') {
      _eurCash -= fromAmount;
      _usdCash += toAmount;
      _usdFundInvestment += fromAmount;
      _usdFundValue += toAmount;
    } else if (fromCurrency == 'USD' && toCurrency == 'EUR') {
      _usdCash -= fromAmount;
      _eurCash += toAmount;
      
      // Realize gain/loss on fund
      double gainPercentage = fromAmount / _usdFundValue;
      double gainRealized = gainPercentage * (_usdFundValue - _usdFundInvestment);
      _gainRealizedFund += gainRealized;
      _usdFundInvestment -= gainPercentage * _usdFundInvestment;
      _usdFundValue -= fromAmount;
    }

    _recalculate();
    notifyListeners();
  }

  void addSecurityTransaction(
    DateTime date,
    String symbol,
    String securityType,
    String currency,
    double quantity,
    double pricePerUnit,
    double commission,
    bool isSell,
  ) {
    double effectivePrice = pricePerUnit;
    double totalCost = quantity * pricePerUnit + commission;

    if (!isSell) {
      // Buy
      effectivePrice = totalCost / quantity;
      
      _transactions.add(
        Transaction(
          id: DateTime.now().toString(),
          type: TransactionType.buy,
          date: date,
          symbol: symbol,
          currency: currency,
          quantity: quantity,
          price: effectivePrice,
          commission: commission,
          securityType: securityType,
        ),
      );

      if (currency == 'EUR') {
        _eurCash -= totalCost;
      } else if (currency == 'USD') {
        _usdCash -= totalCost;
      }
    } else {
      // Sell
      double netProceeds = quantity * pricePerUnit - commission;
      
      _transactions.add(
        Transaction(
          id: DateTime.now().toString(),
          type: TransactionType.sell,
          date: date,
          symbol: symbol,
          currency: currency,
          quantity: quantity,
          price: pricePerUnit - (commission / quantity),
          commission: commission,
          securityType: securityType,
        ),
      );

      if (currency == 'EUR') {
        _eurCash += netProceeds;
      } else if (currency == 'USD') {
        _usdCash += netProceeds;
      }
    }

    _recalculate();
    notifyListeners();
  }

  void addDividend(
    DateTime date,
    String symbol,
    double amount,
    String currency,
  ) {
    _transactions.add(
      Transaction(
        id: DateTime.now().toString(),
        type: TransactionType.dividend,
        date: date,
        symbol: symbol,
        currency: currency,
        amount: amount,
      ),
    );

    if (currency == 'EUR') {
      _eurCash += amount;
    } else if (currency == 'USD') {
      _usdCash += amount;
    }

    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    // Logica di ricalcolo MWR e performance
    // TODO: Implementare calcolo completo
  }

  Map<String, SecurityPosition> getSecurityPositions() {
    Map<String, SecurityPosition> positions = {};
    
    for (var tx in _transactions) {
      if (tx.type == TransactionType.buy || tx.type == TransactionType.sell) {
        String key = '${tx.symbol}_${tx.currency}';
        
        if (!positions.containsKey(key)) {
          positions[key] = SecurityPosition(
            symbol: tx.symbol!,
            currency: tx.currency,
            securityType: tx.securityType ?? 'Unknown',
          );
        }

        if (tx.type == TransactionType.buy) {
          positions[key]!.quantity += tx.quantity!;
          positions[key]!.totalCost += (tx.price! * tx.quantity!) + (tx.commission ?? 0);
        } else {
          positions[key]!.quantity -= tx.quantity!;
          positions[key]!.totalCost -= (tx.price! * tx.quantity!) - (tx.commission ?? 0);
        }
      }
    }

    // Remove zero positions
    positions.removeWhere((key, value) => value.quantity <= 0);
    return positions;
  }

  double getTotalPortfolioValue() {
    double eurValue = _eurCash;
    double usdValue = _usdCash;
    
    // Add security values
    var positions = getSecurityPositions();
    positions.forEach((key, pos) {
      if (pos.currency == 'EUR') {
        eurValue += pos.currentValue;
      } else {
        usdValue += pos.currentValue;
      }
    });

    // Add fund USD value
    usdValue += _usdFundValue;
    
    // Convert to EUR
    return eurValue + (usdValue * _currentUsdRate);
  }

  double getTotalInvested() {
    double total = _usdFundInvestment;
    
    var positions = getSecurityPositions();
    positions.forEach((key, pos) {
      total += pos.totalCost;
    });

    return total;
  }

  double getMWRPercentage() {
    double invested = getTotalInvested();
    if (invested == 0) return 0;
    
    double current = getTotalPortfolioValue();
    return ((current - invested) / invested) * 100;
  }
}

class Transaction {
  final String id;
  final TransactionType type;
  final DateTime date;
  final String? symbol;
  final String currency;
  final String? securityType;
  final double? quantity;
  final double? price;
  final double? commission;
  final double? amount;
  final double? exchangeRate;

  Transaction({
    required this.id,
    required this.type,
    required this.date,
    this.symbol,
    required this.currency,
    this.securityType,
    this.quantity,
    this.price,
    this.commission,
    this.amount,
    this.exchangeRate,
  });
}

enum TransactionType { deposit, withdrawal, buy, sell, dividend, exchange }

class SecurityPrice {
  final String symbol;
  final String currency;
  final double price;
  final DateTime timestamp;

  SecurityPrice({
    required this.symbol,
    required this.currency,
    required this.price,
    required this.timestamp,
  });
}

class SecurityPosition {
  final String symbol;
  final String currency;
  final String securityType;
  double quantity = 0;
  double totalCost = 0;
  double currentPrice = 0;

  SecurityPosition({
    required this.symbol,
    required this.currency,
    required this.securityType,
  });

  double get currentValue => quantity * currentPrice;
  double get gainLoss => currentValue - totalCost;
  double get gainLossPercentage => totalCost == 0 ? 0 : (gainLoss / totalCost) * 100;
  double get averageCost => quantity == 0 ? 0 : totalCost / quantity;
}
