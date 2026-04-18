import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/portfolio_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioModel>(
      builder: (context, portfolio, child) {
        List<Transaction> transactions = portfolio.transactions;

        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nessuna transazione',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButton<String>(
                value: _filterType,
                isExpanded: true,
                onChanged: (value) {
                  setState(() => _filterType = value ?? 'all');
                },
                items: [
                  const DropdownMenuItem(
                    value: 'all',
                    child: Text('Tutte le transazioni'),
                  ),
                  const DropdownMenuItem(
                    value: 'buy',
                    child: Text('Acquisti'),
                  ),
                  const DropdownMenuItem(
                    value: 'sell',
                    child: Text('Vendite'),
                  ),
                  const DropdownMenuItem(
                    value: 'dividend',
                    child: Text('Dividendi'),
                  ),
                  const DropdownMenuItem(
                    value: 'deposit',
                    child: Text('Versamenti'),
                  ),
                  const DropdownMenuItem(
                    value: 'exchange',
                    child: Text('Cambi valuta'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[transactions.length - 1 - index];
                  
                  if (_filterType != 'all' &&
                      tx.type.toString().split('.').last != _filterType) {
                    return const SizedBox.shrink();
                  }

                  return _buildTransactionCard(tx);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionCard(Transaction tx) {
    IconData icon;
    Color color;
    String description;

    switch (tx.type) {
      case TransactionType.buy:
        icon = Icons.trending_down;
        color = Colors.red;
        description =
            '${tx.quantity!.toStringAsFixed(2)} ${tx.symbol} @ ${tx.currency} ${tx.price!.toStringAsFixed(2)}';
        break;
      case TransactionType.sell:
        icon = Icons.trending_up;
        color = Colors.green;
        description =
            '${tx.quantity!.toStringAsFixed(2)} ${tx.symbol} @ ${tx.currency} ${tx.price!.toStringAsFixed(2)}';
        break;
      case TransactionType.dividend:
        icon = Icons.card_giftcard;
        color = Colors.blue;
        description = '${tx.currency} ${tx.amount!.toStringAsFixed(2)}';
        break;
      case TransactionType.deposit:
        icon = Icons.arrow_downward;
        color = Colors.green;
        description = '${tx.currency} ${tx.amount!.toStringAsFixed(2)}';
        break;
      case TransactionType.exchange:
        icon = Icons.swap_horiz;
        color = Colors.purple;
        description = tx.currency;
        break;
      case TransactionType.withdrawal:
        icon = Icons.arrow_upward;
        color = Colors.red;
        description = '${tx.currency} ${tx.amount!.toStringAsFixed(2)}';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTitle(tx.type),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd/MM/yy').format(tx.date),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(tx.date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTransactionTitle(TransactionType type) {
    switch (type) {
      case TransactionType.buy:
        return 'Acquisto';
      case TransactionType.sell:
        return 'Vendita';
      case TransactionType.dividend:
        return 'Dividendo';
      case TransactionType.deposit:
        return 'Versamento';
      case TransactionType.exchange:
        return 'Cambio valuta';
      case TransactionType.withdrawal:
        return 'Prelievo';
    }
  }
}
