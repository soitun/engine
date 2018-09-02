import React from 'react';
import { Link } from 'react-router-dom';
import { truncate } from 'lodash';

// Components
import Icons from '../../../../components/icons';
import EditIcon from '../../../../components/icons/edit';

const Section = ({ image, text, section, definition, ...props })=> {
  const Icon = Icons[definition.icon];

  return (
    <div className="editor-list-item">
      {image && (
        <div className="editor-list-item--image" style={{ backgroundImage: `url("${image}")` }}>
        </div>
      )}
      {!image && (
        <div className="editor-list-item--icon">
          {Icon && <Icon />}
        </div>
      )}
      <div className="editor-list-item--label">
        {truncate(text || section.label || definition.name, { length: 32 })}
      </div>
      <div className="editor-list-item--actions">
        <Link to={props.editPath} className="editor-section--edit-button">
          <EditIcon />
        </Link>
      </div>
    </div>
  )
}

export default Section;
