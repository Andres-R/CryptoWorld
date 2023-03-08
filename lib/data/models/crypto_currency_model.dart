class CryptoCurrency {
  final String id;
  final String name;
  final String symbol;
  final dynamic price;
  final dynamic percentChange1Hour;
  final dynamic percentChange24Hour;
  final dynamic percentChange7Day;
  final dynamic percentChange30Day;
  final dynamic percentChange60Day;
  final dynamic percentChange90Day;
  final dynamic marketCap;
  final dynamic marketCapDominance;
  final dynamic fullyDilutedMarketCap;
  final dynamic volume24h;
  final dynamic percentVolumeChange24h;
  final dynamic maxSupply;
  final dynamic circulatingSupply;
  final dynamic totalSupply;
  final dynamic cmcRank;

  CryptoCurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentChange1Hour,
    required this.percentChange24Hour,
    required this.percentChange7Day,
    required this.percentChange30Day,
    required this.percentChange60Day,
    required this.percentChange90Day,
    required this.marketCap,
    required this.marketCapDominance,
    required this.fullyDilutedMarketCap,
    required this.volume24h,
    required this.percentVolumeChange24h,
    required this.maxSupply,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.cmcRank,
  });
}
