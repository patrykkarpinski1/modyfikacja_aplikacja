import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modyfikacja_aplikacja/features/detalis/pages/detalis_note.dart';
import 'package:modyfikacja_aplikacja/features/home/pages/notepad/cubit/notepad_cubit.dart';
import 'package:modyfikacja_aplikacja/models/note_model.dart';
import 'package:modyfikacja_aplikacja/widgets/icon_show_alert_dialog_widget.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    Key? key,
    required this.noteModel,
  }) : super(key: key);
  final NoteModel noteModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => DetalisNotePage(
                    id: noteModel.id,
                  )),
        );
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    noteModel.note,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      noteModel.releaseDate.day.toString(),
                      style: GoogleFonts.gruppo(
                          color: const Color.fromARGB(255, 29, 28, 28),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  AlertWidget(
                      onPressed: () {
                        context
                            .read<NotepadCubit>()
                            .remove(documentID: noteModel.id);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_sweep_outlined))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
