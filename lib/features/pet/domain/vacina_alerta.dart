import '../../../core/utils/br_date.dart';
import 'vacina.dart';

/// RF23: alertar o tutor quando a próxima dose estiver próxima ou vencida.
/// Nesta fase, o "alerta" é só visual no app (sem notificação push) — ver
/// decisão registrada no README/roadmap.
enum VacinaAlerta { nenhum, proxima, vencida }

const _diasParaConsiderarProxima = 30;

VacinaAlerta calcularAlerta(Vacina vacina, {DateTime? agora}) {
  final proximaDose = parseBrDate(vacina.proximaDose ?? '');
  if (proximaDose == null) return VacinaAlerta.nenhum;

  final hoje = agora ?? DateTime.now();
  final hojeSemHora = DateTime(hoje.year, hoje.month, hoje.day);
  final diasRestantes = proximaDose.difference(hojeSemHora).inDays;

  if (diasRestantes < 0) return VacinaAlerta.vencida;
  if (diasRestantes <= _diasParaConsiderarProxima) return VacinaAlerta.proxima;
  return VacinaAlerta.nenhum;
}
