import '../../../core/utils/br_date.dart';
import 'consulta.dart';

/// RF30: notificar o tutor sobre consultas agendadas próximas. Nesta fase,
/// o "alerta" é só visual no app (sem notificação push) — mesma decisão já
/// tomada para o alerta de vacina (RF23, ver README/roadmap).
const _diasParaConsiderarProxima = 7;

bool consultaEstaProxima(Consulta consulta, {DateTime? agora}) {
  if (consulta.status != ConsultaStatus.agendada) return false;

  final data = parseBrDate(consulta.data);
  if (data == null) return false;

  final hoje = agora ?? DateTime.now();
  final hojeSemHora = DateTime(hoje.year, hoje.month, hoje.day);
  final diasRestantes = data.difference(hojeSemHora).inDays;

  return diasRestantes >= 0 && diasRestantes <= _diasParaConsiderarProxima;
}
