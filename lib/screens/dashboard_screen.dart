import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/portfolio_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioModel>(
      builder: (context, portfolio, child) {
        double totalValue = portfolio.getTotalPortfolioValue();
        double invested = portfolio.getTotalInvested();
        double gainLoss = totalValue - invested;
        double mwr = portfolio.getMWRPercentage();
        
        bool isPositive = gainLoss >= 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Value Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1F4788),
                        const Color(0xFF2A5AA0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valore Totale Portafoglio',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '€ ${NumberFormat('#,##0.00', 'it_IT').format(totalValue)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Versamenti',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '€ ${NumberFormat('#,##0.00', 'it_IT').format(invested)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Gain/Loss',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${isPositive ? '+' : ''}€ ${NumberFormat('#,##0.00', 'it_IT').format(gainLoss)}',
                                style: TextStyle(
                                  color: isPositive ? Colors.green[300] : Colors.red[300],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // MWR Card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Money-Weighted Return (MWR)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F4788),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${mwr.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isPositive ? Colors.green[700] : Colors.red[700],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPositive ? '↗ Positivo' : '↘ Negativo',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isPositive
                                    ? Colors.green[700]
                                    : Colors.red[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Breakdown EUR/USD
              const Text(
                'Breakdown Conti',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F4788),
                ),
              ),
              const SizedBox(height: 12),
              _buildCurrencyCard(
                currency: 'EUR',
                icon: '💶',
                value: portfolio.eurCash,
                percentage: (portfolio.eurCash / totalValue) * 100,
              ),
              const SizedBox(height: 12),
              _buildCurrencyCard(
                currency: 'USD',
                icon: '💵',
                value: (portfolio.usdCash + portfolio.usdFundValue) *
                    portfolio.currentUsdRate,
                percentage:
                    ((portfolio.usdCash + portfolio.usdFundValue) *
                            portfolio.currentUsdRate /
                        totalValue) *
                    100,
              ),
              const SizedBox(height: 24),

              // Fondo USD Details
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fondo USD',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F4788),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Investimento:',
                        '€ ${NumberFormat('#,##0.00', 'it_IT').format(portfolio.usdFundInvestment)}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Valore attuale:',
                        '€ ${NumberFormat('#,##0.00', 'it_IT').format(portfolio.usdFundValue * portfolio.currentUsdRate)}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Gain non realizzato:',
                        '€ ${NumberFormat('#,##0.00', 'it_IT').format((portfolio.usdFundValue * portfolio.currentUsdRate) - portfolio.usdFundInvestment)}',
                        color: Colors.green[700],
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Gain realizzato:',
                        '€ ${NumberFormat('#,##0.00', 'it_IT').format(portfolio.gainRealizedFund)}',
                        color: Colors.blue[700],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencyCard({
    required String currency,
    required String icon,
    required double value,
    required double percentage,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '€ ${NumberFormat('#,##0.00', 'it_IT').format(value)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
