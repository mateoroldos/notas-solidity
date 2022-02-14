// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;

contract notas {

    // Direccion del profesor
    address public profesor;
    
    // Constructor
    constructor () public {
        profesor = msg.sender;
    }

    // Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping (bytes32 => uint) Notas;

    // Array de los alumnos que piden revisiones de examen
    string [] revisiones;

    // Eventos
    event alumno_evaluado(bytes32);
    event alumno_revision(string);

    // Función para evaluar al alumno que únicamente puede ejecutarla el profesor
    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender){
        // Hash de la indentificación del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Relacion entre el hash de la identificación del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        // Emision del evento
        emit alumno_evaluado(hash_idAlumno);
    }

    // Modifier que permite únicamente al profesor ejecutar la función anterior
    modifier UnicamenteProfesor(address _direccion){
        // Require que la direccion introducido por parametro sea igual al owner del contrato
        require(_direccion == profesor, "No tienes permisos para ejecutar esta funcion.");
        _;
    }

    // Funcion para ver las notas de un alumno
    function VerNotas(string memory _idAlumno) public view returns(uint) {
        // Hash de la indentificación del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Nota asociada al hash del alumno
        uint nota_alumno = Notas[hash_idAlumno];
        // Visualizar la nota
        return nota_alumno;
    } 

    // Funcion para pedir revisión de su nota
    function Revision(string memory _idAlumno) public {
        // Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        // Emision del evento
        emit alumno_revision(_idAlumno);
    }

    // Funcion para ver los alumnos que han solicitado revision de examen
    function VerRevisiones() public view UnicamenteProfesor(msg.sender) returns(string [] memory){
        // Devolver el array con las identidades que han pedido revision
        return revisiones;
    }
}
