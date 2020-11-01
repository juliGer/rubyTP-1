module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          Dir.chdir("/home/#{ENV["USER"]}")
          if(!Dir.exists? ".my_rns")
            puts "No existe la carpeta .my_rns, debe crearla y crear un book"
          else
            Dir.chdir(".my_rns")
            if book
              if(Dir.exists? book)
                Dir.chdir(book)
                File.open(title, "w")
              else
                puts "No existe el libro que envió como parametro debe crearlo"
              end
            else
              Dir.chdir("cuaderno_global")
              File.open(title, "w")              
            end
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          Dir.chdir("/home/#{ENV["USER"]}")
          if(!Dir.exists? ".my_rns")
            puts "No existe la carpeta .my_rns, debe crearla y crear un book"
          else
            Dir.chdir(".my_rns")
            if book
              if(Dir.exists? book)
                Dir.chdir(book)
                if(Dir.exists? title)
                  File.delete(title)
                else
                  puts "No existe la nota que envio en el libro que envio"
                end
              else
                puts "No existe el libro que envió como parametro debe crearlo"
              end
            else
              Dir.chdir("cuaderno_global")
              File.delete(title)
            end
          end
        end
      end

      class Edit < Dry::CLI::Command
        require 'tty-editor'

        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          Dir.chdir("/home/#{ENV["USER"]}")
          if(!Dir.exists? ".my_rns")
            puts "No existe la carpeta .my_rns, debe crearla y crear un book"
          else
            Dir.chdir(".my_rns")
            if book
              if(Dir.exists? book)
                Dir.chdir(book)
                if(File.exists? title)
                  TTY::Editor.open("#{title}")
                else
                  "No existe la nota que envio en el libro que envio"
                end
              else
                puts "No existe el libro que envió como parametro debe crearlo"
              end
            else
              Dir.chdir("cuaderno_global")
              if(File.exists? title)
                TTY::Editor.open("#{title}")
              else
                "No existe la nota que envio en el libro que envio"
              end
            end
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          Dir.chdir("/home/#{ENV["USER"]}")
          if(!Dir.exists? ".my_rns")
            puts "No existe la carpeta .my_rns, debe crearla y crear un book"
          else
            Dir.chdir(".my_rns")
            if book
              if(Dir.exists? book)
                Dir.chdir(book)
                if(File.exists? old_title)
                  File.rename(old_title, new_title)
                else
                  "No existe la nota que envio en el libro que envio"
                end
              else
                puts "No existe el libro que envió como parametro debe crearlo"
              end
            else
              Dir.chdir("cuaderno_global")
              if(File.exists? old_title)
                File.rename(old_title, new_title)
              else
                "No existe la nota que envio en el libro que envio"
              end
            end
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          Dir.chdir("/home/#{ENV["USER"]}")
          if(!Dir.exists? ".my_rns")
            puts "No existe la carpeta .my_rns, debe crearla y crear un book"
          else
            Dir.chdir(".my_rns")
            if book
              if(Dir.exists? book)
                Dir.chdir(book)
                system("ls")
              else
                puts "No existe el libro que envió como parametro debe crearlo"
              end
            else
              Dir.chdir("cuaderno_global")
              system("ls")
            end
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          Dir.chdir("/home/#{ENV["USER"]}")
          if(!Dir.exists? ".my_rns")
            puts "No existe la carpeta .my_rns, debe crearla y crear un book"
          else
            Dir.chdir(".my_rns")
            if book
              if(Dir.exists? book)
                Dir.chdir(book)
                if(File.exists? title)
                  puts File.read(title)
                else
                  "No existe la nota que envio en el libro que envio"
                end
              else
                puts "No existe el libro que envió como parametro debe crearlo"
              end
            else
              Dir.chdir("cuaderno_global")
              if(File.exists? title)
                puts File.read(title)
              else
                "No existe la nota que envio en el libro que envio"
              end
            end
          end
        end
      end
    end
  end
end
