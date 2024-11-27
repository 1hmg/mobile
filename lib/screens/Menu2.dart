import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'EditarPerfil.dart'; // Página de edição de perfil

class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name; // Nome do usuário
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;

  // Dados de perfil adicionais
  String? _weight = '0.0';
  String? _height = '0.0';
  String? _age = '0';
  String? _neck = '0.0';
  String? _waist = '0.0';
  String? _hip = '0.0';
  String? _sex = '?'; // Campo de sexo, padrão '?' se não for definido

  // Cálculos de IMC e BF
  String? _bmi = '0.0';
  String? _bfPercentage = '0.0';

  // Variável para controlar o carregamento
  bool _isLoading = true;

  final ImagePicker _picker = ImagePicker(); // Instancia do ImagePicker

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    int userId = widget.userId;

    if (userId != -1) {
      try {
        // Primeira requisição para buscar o nome do usuário
        String nameUrl = 'http://localhost:8080/alunos/$userId';  // URL para buscar o nome
        final nameResponse = await http.get(Uri.parse(nameUrl));

        if (nameResponse.statusCode == 200) {
          var nameData = jsonDecode(nameResponse.body);
          setState(() {
            _name = nameData['nome'];  // Atualiza o nome do usuário
          });
        } else {
          print('Falha ao carregar o nome. Status Code: ${nameResponse.statusCode}');
        }

        // Segunda requisição para buscar as informações adicionais
        String attributesUrl = 'http://localhost:8080/atributos/$userId';  // URL para buscar as informações do perfil
        final attributesResponse = await http.get(Uri.parse(attributesUrl));

        if (attributesResponse.statusCode == 200) {
          var data = jsonDecode(attributesResponse.body);

          setState(() {
            _weight = data['peso']?.toString() ?? '0.0';
            _height = data['altura']?.toString() ?? '0.0';
            _age = data['idade']?.toString() ?? '0';
            _neck = data['pescoco']?.toString() ?? '0.0';
            _waist = data['cintura']?.toString() ?? '0.0';
            _hip = data['quadril']?.toString() ?? '0.0';
            _sex = data['sexo'] ?? '?'; // Atualiza o sexo
          });

          // Calculando IMC e BF
          _calculateBMI();
          _calculateBF();
        } else {
          print('Falha ao carregar os dados adicionais. Status Code: ${attributesResponse.statusCode}');
        }

        setState(() {
          _isLoading = false;  // Desativa o indicador de carregamento
        });
      } catch (e) {
        print('Erro ao carregar os dados: $e');
        setState(() {
          _isLoading = false;  // Desativa o indicador de carregamento em caso de erro
        });
      }
    } else {
      print('ID do usuário inválido.');
      setState(() {
        _isLoading = false;  // Desativa o indicador de carregamento
      });
    }
  }

  // Método para calcular o IMC
  void _calculateBMI() {
  if (_weight != null && _height != null) {
    double weight = double.parse(_weight!);
    double height = double.parse(_height!) / 100;  // altura em metros

    double bmi = weight / (height * height);
    setState(() {
      _bmi = bmi.toStringAsFixed(1);
    });

    // Após calcular o IMC, também chama o cálculo de BF
    _calculateBF();  // Certifica-se de que o cálculo de BF seja feito logo após o IMC
  }
}

// Método para calcular o percentual de gordura (BF)
void _calculateBF() {
  if (_bmi != null && _age != null && _sex != null) {
    double bmiValue = double.parse(_bmi!);
    int ageValue = int.parse(_age!);

    double bf = 0.0;

    // Fórmulas para calcular o BF baseado no sexo
    if (_sex == 'M') {
      bf = 1.20 * bmiValue + 0.23 * ageValue - 16.2;
    } else if (_sex == 'F') {
      bf = 1.20 * bmiValue + 0.23 * ageValue - 5.4;
    }

    setState(() {
      _bfPercentage = bf.toStringAsFixed(1); // Atualiza o percentual de gordura
    });

    // Após calcular o BF, envie os resultados
    _sendResultsToServer();
  } else {
    print('Dados insuficientes para calcular o BF.');
  }
}

// Função para enviar os resultados para o servidor
Future<void> _sendResultsToServer() async {
  int userId = widget.userId;

  if (userId != -1 && _bmi != null && _bfPercentage != null) {
    try {
      String url = 'http://localhost:8080/resultados/$userId';

      // Dados a serem enviados
      Map<String, String> body = {
        'imc': _bmi ?? '0.0',
        'ibf': _bfPercentage ?? '0.0',
      };

      // Requisição PUT para enviar os resultados
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Resultados enviados com sucesso.');
      } else {
        print('Falha ao enviar os resultados. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar os resultados: $e');
    }
  } else {
    print('Dados incompletos para envio: IMC e BF não podem ser nulos.');
  }
}
  // Método para lidar com a atualização dos dados após a edição
  void _updateProfileData(Map<String, String> updatedData) {
    setState(() {
      _weight = updatedData['peso'];
      _height = updatedData['altura'];
      _age = updatedData['idade'];
      _neck = updatedData['pescoco'];
      _waist = updatedData['cintura'];
      _hip = updatedData['quadril'];
      _sex = updatedData['sexo'];
    });

    // Recalcula IMC e BF após atualizar os dados
    _calculateBMI();
    _calculateBF();
  }

  // Método para escolher ou tirar uma foto para o perfil
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery); // Abre a galeria

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path; // Atualiza o caminho da imagem
      });
    }
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Container(
          width: 120,
          child: TextField(
            controller: TextEditingController(text: value ?? '0.0'),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '0.0',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            enabled: false, // Apenas leitura
          ),
        ),
        SizedBox(width: 8),
        Text(label == 'Peso' || label == 'Altura' || label == 'Cintura' || label == 'Pescoço' || label == 'Quadril' ? 'kg' : label == 'Idade' ? 'anos' : '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Exibe um indicador de carregamento enquanto os dados não foram carregados
          if (_isLoading)
            Center(child: CircularProgressIndicator()) // Mostra o spinner enquanto carrega
          else
            Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,  // Permite escolher a imagem
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!))
                        : NetworkImage('https://www.w3schools.com/w3images/avatar2.png') as ImageProvider,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _isEditingName
                        ? Expanded(child: TextField(controller: _nameController, decoration: InputDecoration(hintText: 'Digite seu nome'))): 
                        Text(_name ?? 'Nome do Usuário', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(_isEditingName ? Icons.check : Icons.edit),
                      onPressed: () {
                        if (_isEditingName) {
                          // Atualiza o nome no servidor
                          _updateUserName(_nameController.text);
                        } else {
                          _nameController.text = _name ?? ''; // Coloca o nome atual no campo
                        }
                        setState(() {
                          _isEditingName = !_isEditingName;
                        });
                      },
                    ),
                  ],
                ),
                Divider(),
                _buildInfoRow('Peso', _weight),
                _buildInfoRow('Altura', _height),
                _buildInfoRow('Idade', _age),
                _buildInfoRow('Pescoço', _neck),
                _buildInfoRow('Cintura', _waist),
                _buildInfoRow('Quadril', _hip),
                _buildInfoRow('Sexo', _sex),
                Divider(),
                Text('IMC: $_bmi', style: TextStyle(fontSize: 20)),
                Text('Percentual de Gordura: $_bfPercentage%', style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: () async {
                    final updatedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          userId: widget.userId,
                          currentProfileData: {
                            'peso': _weight ?? '',
                            'altura': _height ?? '',
                            'idade': _age ?? '',
                            'pescoco': _neck ?? '',
                            'cintura': _waist ?? '',
                            'quadril': _hip ?? '',
                            'sexo': _sex ?? '',
                          },
                        ),
                      ),
                    );

                    if (updatedData != null) {
                      _updateProfileData(updatedData);
                    }
                  },
                  child: Text('Editar Perfil'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _updateUserName(String newName) async {
    // Aqui você pode implementar a lógica para atualizar o nome no servidor
    // Exemplo:
    // await http.put(Uri.parse('http://localhost:8080/update-name'),
    //     body: {'name': newName});
  }
}
