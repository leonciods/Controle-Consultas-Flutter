# Sistema UPA - Módulo Médico

**Trabalho da disciplina Programação para Dispositivos Móveis - IFRS**

## Sobre o Projeto

Aplicativo mobile desenvolvido em Flutter que simula o sistema usado por médicos em uma UPA (Unidade de Pronto Atendimento). O app permite gerenciar consultas, criar receitas e atestados médicos digitais.

## Funcionalidades

- Visualizar lista de consultas
- Ver detalhes de cada consulta
- CRUD de receitas médicas
- Campos da receita: medicamento, dosagem, duração e observações
- CRUD de atestados médicos
- Campos do atestado: CID, dias de afastamento, data de início e observações

## Tecnologias

- **Frontend:** Flutter (Dart)
- **Backend:** Python + Flask - https://github.com/leonciods/Controle-consultas
- **Banco:** Google Firestore
- **API:** REST

## Como Executar

### Backend
```bash
pip install flask flask-cors google-cloud-firestore
python app.py
```

### App Mobile
```bash
flutter pub get
flutter run
```

*Projeto desenvolvido para IFRS - 2025*
